import ./make-test-python.nix (
  {pkgs, ...}: let
    sshKeys = import (pkgs.path + "/nixos/tests/ssh-keys.nix") pkgs;
    sshUsername = "any-user";
    serverName = "server";
    clientName = "client";
    sshAuditPort = 2222;
  in {
    name = "ssh";

    nodes = {
      "${serverName}" = {
        networking.firewall.allowedTCPPorts = [
          sshAuditPort
        ];
        services.openssh.enable = true;
        users.users."${sshUsername}" = {
          isNormalUser = true;
          openssh.authorizedKeys.keys = [
            sshKeys.snakeOilPublicKey
          ];
        };
      };
      "${clientName}" = {
        programs.ssh = {
          ciphers = [
            "aes128-ctr"
            "aes128-gcm@openssh.com"
            "aes192-ctr"
            "aes256-ctr"
            "aes256-gcm@openssh.com"
            "chacha20-poly1305@openssh.com"
          ];
          extraConfig = ''
            IdentitiesOnly yes
          '';
          hostKeyAlgorithms = [
            "rsa-sha2-256"
            "rsa-sha2-256-cert-v01@openssh.com"
            "rsa-sha2-512"
            "rsa-sha2-512-cert-v01@openssh.com"
            "sk-ssh-ed25519-cert-v01@openssh.com"
            "sk-ssh-ed25519@openssh.com"
            "ssh-ed25519"
            "ssh-ed25519-cert-v01@openssh.com"
          ];
          kexAlgorithms = [
            "curve25519-sha256"
            "curve25519-sha256@libssh.org"
            "diffie-hellman-group-exchange-sha256"
            "diffie-hellman-group16-sha512"
            "diffie-hellman-group18-sha512"
            "sntrup761x25519-sha512@openssh.com"
          ];
          macs = [
            "hmac-sha2-256-etm@openssh.com"
            "hmac-sha2-512-etm@openssh.com"
            "umac-128-etm@openssh.com"
          ];
        };
      };
    };

    testScript = ''
      start_all()

      ${serverName}.wait_for_open_port(22)

      # Should pass SSH server audit
      ${serverName}.succeed("${pkgs.ssh-audit}/bin/ssh-audit 127.0.0.1")

      # Wait for client to be able to connect to the server
      ${clientName}.wait_for_unit("network-online.target")

      # Set up trusted private key
      ${clientName}.succeed("cat ${sshKeys.snakeOilPrivateKey} > privkey.snakeoil")
      ${clientName}.succeed("chmod 600 privkey.snakeoil")

      # Fail fast and disable interactivity
      ssh_options = "-o BatchMode=yes -o ConnectTimeout=1 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

      # Should deny root user
      ${clientName}.fail(f"ssh {ssh_options} root@${serverName} true")

      # Should deny non-root user password login
      ${clientName}.fail(f"ssh {ssh_options} -o PasswordAuthentication=yes ${sshUsername}@${serverName} true")

      # Should allow non-root user certificate login
      ${clientName}.succeed(f"ssh {ssh_options} -i privkey.snakeoil ${sshUsername}@${serverName} true")

      # Should pass SSH client audit
      service_name = "ssh-audit.service"
      ${serverName}.succeed(f"systemd-run --unit={service_name} ${pkgs.ssh-audit}/bin/ssh-audit --client-audit --port=${toString sshAuditPort}")
      ${clientName}.sleep(5) # We can't use wait_for_open_port because ssh-audit exits as soon as anything talks to it
      ${clientName}.execute(
          f"ssh {ssh_options} -i privkey.snakeoil -p ${toString sshAuditPort} ${sshUsername}@${serverName} true",
          check_return=False,
          timeout=10
      )
      ${serverName}.succeed(f"exit $(systemctl show --property=ExecMainStatus --value {service_name})")
    '';
  }
)
