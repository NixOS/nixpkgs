{ hostPkgs, ... }:

# This test recreates a remote deployment scenario where the connection
# between deployer and target is closed during the deployment - in this
# case because the connection goes over a 'reverse ssh' tunnel service
# that has changes that are being deployed.

# This is not seamless (the deployer doesn't get to see the logs after
# the disconnect), but is a lot better than the old behaviour, where
# the switch was aborted and the connection never restored.

{
  name = "nixos-rebuild-target-host-interrupted";

  # TODO: remove overlay from  nixos/modules/profiles/installation-device.nix
  #        make it a _small package instead, then remove pkgsReadOnly = false;.
  node.pkgsReadOnly = false;

  nodes = {
    deployer =
      {
        nodes,
        lib,
        pkgs,
        ...
      }:
      let
        inherit (import ./ssh-keys.nix pkgs) snakeOilPrivateKey snakeOilPublicKey;
      in
      {
        imports = [
          ../modules/profiles/installation-device.nix
        ];

        nix.settings = {
          substituters = lib.mkForce [ ];
          hashed-mirrors = null;
          connect-timeout = 1;
        };

        system.includeBuildDependencies = true;

        virtualisation = {
          cores = 2;
          memorySize = 3072;
        };

        services.openssh.enable = true;
        users.users.root.openssh.authorizedKeys.keys = [ nodes.target.system.build.publicKey ];
        system.extraDependencies = [
          # so that it doesn't need to be built inside the test
          pkgs.nixVersions.latest
        ];

        system.build.privateKey = snakeOilPrivateKey;
        system.build.publicKey = snakeOilPublicKey;
        system.switch.enable = true;

        services.getty.autologinUser = lib.mkForce "root";
      };

    target =
      {
        nodes,
        lib,
        pkgs,
        ...
      }:
      let
        inherit (import ./ssh-keys.nix pkgs) snakeOilPrivateKey snakeOilPublicKey;
        targetConfig = {
          documentation.enable = false;
          services.openssh.enable = true;
          system.build.privateKey = snakeOilPrivateKey;
          system.build.publicKey = snakeOilPublicKey;

          users.users.root.openssh.authorizedKeys.keys = [ nodes.deployer.system.build.publicKey ];
          users.users.alice.openssh.authorizedKeys.keys = [ nodes.deployer.system.build.publicKey ];
          users.users.bob.openssh.authorizedKeys.keys = [ nodes.deployer.system.build.publicKey ];

          users.users.alice.extraGroups = [ "wheel" ];
          users.users.bob.extraGroups = [ "wheel" ];

          # Disable sudo for root to ensure sudo isn't called without `--sudo`
          security.sudo.extraRules = lib.mkForce [
            {
              groups = [ "wheel" ];
              commands = [ { command = "ALL"; } ];
            }
            {
              users = [ "alice" ];
              commands = [
                {
                  command = "ALL";
                  options = [ "NOPASSWD" ];
                }
              ];
            }
          ];

          nix.settings.trusted-users = [ "@wheel" ];

          systemd.services."autossh-ng" = {
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              User = "root";
              Restart = "always";
              RestartSec = "10s";
              ExecStart = "${pkgs.openssh}/bin/ssh -o \"ServerAliveInterval 30\" -o \"ServerAliveCountMax 3\" -o ExitOnForwardFailure=yes -N -R2222:localhost:22 deployer";
            };
          };

        };
      in
      {
        imports = [ ./common/user-account.nix ];

        config = lib.mkMerge [
          targetConfig
          {
            system.build = {
              inherit targetConfig;
            };
            system.switch.enable = true;

            networking.hostName = "target";
          }
        ];
      };
  };

  testScript =
    { nodes, ... }:
    let
      sshConfig = builtins.toFile "ssh.conf" ''
        UserKnownHostsFile=/dev/null
        StrictHostKeyChecking=no
      '';

      targetConfigJSON = hostPkgs.writeText "target-configuration.json" (
        builtins.toJSON nodes.target.system.build.targetConfig
      );

      targetNetworkJSON = hostPkgs.writeText "target-network.json" (
        builtins.toJSON nodes.target.system.build.networkConfig
      );

      configFile =
        hostname:
        hostPkgs.writeText "configuration.nix" # nix
          ''
            { lib, pkgs, modulesPath, ... }: {
              imports = [
                (modulesPath + "/virtualisation/qemu-vm.nix")
                (modulesPath + "/testing/test-instrumentation.nix")
                (modulesPath + "/../tests/common/user-account.nix")
                (lib.modules.importJSON ./target-configuration.json)
                (lib.modules.importJSON ./target-network.json)
                ./hardware-configuration.nix
              ];

              boot.loader.grub = {
                enable = true;
                device = "/dev/vda";
                forceInstall = true;
              };

              # needed to make NIX_SSHOPTS work for nix-copy-closure
              nix.package = pkgs.nixVersions.latest;

              # We're changing the '-E' parameter to the new hostname here,
              # not because we care about the logs, but because we want to
              # force the scenario where the connection is broken during the
              # deployment (because the autossh-ng service is stopped and
              # started):
              systemd.services."autossh-ng".serviceConfig.ExecStart =
                lib.mkForce "''${pkgs.openssh}/bin/ssh -o \"ServerAliveInterval 30\" -o \"ServerAliveCountMax 3\" -o ExitOnForwardFailure=yes -N -R2222:localhost:22 -E ${hostname} deployer";

              # this will be asserted to validate the switch happened:
              networking.hostName = "${hostname}";
            }
          '';
    in
    # python
    ''
      start_all()
      target.wait_for_open_port(22)

      deployer.wait_until_succeeds("ping -c1 target")
      deployer.succeed("install -Dm 600 ${nodes.deployer.system.build.privateKey} ~root/.ssh/id_ecdsa")
      deployer.succeed("install ${sshConfig} ~root/.ssh/config")

      target.succeed("nixos-generate-config")
      target.succeed("install -Dm 600 ${nodes.target.system.build.privateKey} ~root/.ssh/id_ecdsa")
      target.succeed("install ${sshConfig} ~root/.ssh/config")
      deployer.succeed("scp alice@target:/etc/nixos/hardware-configuration.nix /root/hardware-configuration.nix")
      target.wait_for_unit("autossh-ng.service")

      deployer.copy_from_host("${configFile "config-1-deployed"}", "/root/configuration-1.nix")
      deployer.copy_from_host("${configFile "config-2-deployed"}", "/root/configuration-2.nix")
      deployer.copy_from_host("${targetNetworkJSON}", "/root/target-network.json")
      deployer.copy_from_host("${targetConfigJSON}", "/root/target-configuration.json")

      with subtest("Deploy to alice@target via reverse ssh"):
        deployer.wait_for_unit("multi-user.target")
        # Uses TTY/send_chars instead of deployer.succeed to set NIX_SSHOPTS
        deployer.send_chars("NIX_SSHOPTS=\"-p 2222\" nixos-rebuild switch -I nixos-config=/root/configuration-1.nix --target-host alice@localhost --sudo\n")

        # the connection breaks, but the 'switch' should now continue in the background:
        deployer.wait_until_tty_matches("1", "error: while running command with remote sudo")

        def deployed(last_try: bool) -> bool:
            target_hostname = deployer.succeed("ssh alice@target cat /etc/hostname").rstrip()
            if last_try:
                print(f"Still seeing hostname {target_hostname}")
            return target_hostname == "config-1-deployed"
        retry(deployed)

      with subtest("Deploy to bob@target via reverse ssh with password-based sudo"):
        deployer.wait_for_unit("multi-user.target")
        # Uses TTY/send_chars instead of deployer.succeed to set NIX_SSHOPTS and for ask-sudo-password
        deployer.send_chars("NIX_SSHOPTS=\"-p 2222\" nixos-rebuild switch -I nixos-config=/root/configuration-2.nix --target-host bob@localhost --ask-sudo-password\n")
        deployer.wait_until_tty_matches("1", "password for bob")
        deployer.send_chars("${nodes.target.users.users.bob.password}\n")

        # the connection breaks, but the 'switch' should now continue in the background:
        deployer.wait_until_tty_matches("1", "error: while running command with remote sudo")

        def deployed(last_try: bool) -> bool:
            target_hostname = deployer.succeed("ssh alice@target cat /etc/hostname").rstrip()
            if last_try:
                print(f"Still seeing hostname {target_hostname}")
            return target_hostname == "config-2-deployed"
        retry(deployed)
    '';
}
