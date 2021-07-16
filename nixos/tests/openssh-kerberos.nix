import ./make-test-python.nix ({ pkgs, lib, ... }:

with lib;

let
  krb5 =
    { enable = true;
      domain_realm."ssh.test"   = "SSH.TEST";
      libdefaults.default_realm = "SSH.TEST";
      realms."SSH.TEST" =
        { admin_server = "server.ssh.test";
          kdc = "server.ssh.test";
        };
    };

in

{
  name = "ssh-with-kerberos";

  nodes = {
    client = { lib, ... }:
      { inherit krb5;
        networking.hostName = "client";
        networking.domain = "ssh.test";

        programs.ssh.extraConfig = ''
            GSSAPIAuthentication yes
        '';
      };

    server = { lib, config, ...}:
      { inherit krb5;
        networking.hostName = "server";
        networking.domain = "ssh.test";

        networking.firewall.allowedTCPPorts = [
          88   # kerberos
        ];

        services.kerberos_server.enable = true;
        services.kerberos_server.realms."SSH.TEST" = {};

        services.openssh = {
          enable = true;
          passwordAuthentication = false;
          challengeResponseAuthentication = false;
          extraConfig = ''
            GSSAPIAuthentication yes
          '';
        };
      };
  };

  testScript =
    ''
      start_all()
      # set up kerberos database
      server.succeed(
          "kdb5_util create -s -r SSH.TEST -P master_key",
          "systemctl restart kadmind.service kdc.service",
      )
      server.wait_for_unit("kadmind.service")
      server.wait_for_unit("kdc.service")

      # create principals
      server.succeed(
          "kadmin.local add_principal -randkey host/server.ssh.test",
          "kadmin.local add_principal -pw root_pw root",
      )

      # add principal to keytabs
      server.succeed("kadmin.local ktadd host/server.ssh.test")

      server.wait_for_unit("sshd.service")
      server.succeed("cat /etc/ssh/ssh_host_ed25519_key.pub | sed -E 's/(.*) (.*) .*/server \\1 \\2/' > /tmp/shared/known_hosts")

      with subtest("try ssh as root"):
          client.succeed("mkdir ~/.ssh")
          client.succeed("cp /tmp/shared/known_hosts /root/.ssh")
          client.fail("ssh server ls -l /")
          client.succeed("echo root_pw | kinit -l 00:10")
          client.succeed("ssh server ls -l /")
    '';
})
