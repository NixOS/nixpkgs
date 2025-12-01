{ hostPkgs, ... }:
{
  name = "nixos-rebuild-target-host";

  # TODO: remove overlay from  nixos/modules/profiles/installation-device.nix
  #        make it a _small package instead, then remove pkgsReadOnly = false;.
  node.pkgsReadOnly = false;

  nodes = {
    deployer =
      { lib, pkgs, ... }:
      let
        inherit (import ./ssh-keys.nix pkgs) snakeOilPrivateKey snakeOilPublicKey;
      in
      {
        imports = [ ../modules/profiles/installation-device.nix ];

        nix.settings = {
          substituters = lib.mkForce [ ];
          hashed-mirrors = null;
          connect-timeout = 1;
        };

        environment.systemPackages = [ pkgs.passh ];

        system.includeBuildDependencies = true;

        virtualisation = {
          cores = 2;
          memorySize = 2048;
        };

        system.build.privateKey = snakeOilPrivateKey;
        system.build.publicKey = snakeOilPublicKey;
        system.switch.enable = true;
      };

    target =
      { nodes, lib, ... }:
      let
        targetConfig = {
          documentation.enable = false;
          services.openssh.enable = true;

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
            { lib, modulesPath, ... }: {
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

              nixpkgs.overlays = [
                (final: prev: {
                  # Set tmpdir inside nixos-rebuild-ng to test
                  # "Deploy works with very long TMPDIR"
                  nixos-rebuild-ng = prev.nixos-rebuild-ng.override { withTmpdir = "/tmp"; };
                })
              ];

              # this will be asserted
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
      deployer.succeed("scp alice@target:/etc/nixos/hardware-configuration.nix /root/hardware-configuration.nix")

      deployer.copy_from_host("${configFile "config-1-deployed"}", "/root/configuration-1.nix")
      deployer.copy_from_host("${configFile "config-2-deployed"}", "/root/configuration-2.nix")
      deployer.copy_from_host("${configFile "config-3-deployed"}", "/root/configuration-3.nix")
      deployer.copy_from_host("${targetNetworkJSON}", "/root/target-network.json")
      deployer.copy_from_host("${targetConfigJSON}", "/root/target-configuration.json")

      # Ensure sudo is disabled for root
      target.fail("sudo true")

      # This test also ensures that sudo is not called without --sudo
      with subtest("Deploy to root@target"):
        deployer.succeed("nixos-rebuild switch -I nixos-config=/root/configuration-1.nix --target-host root@target &>/dev/console")
        target_hostname = deployer.succeed("ssh alice@target cat /etc/hostname").rstrip()
        assert target_hostname == "config-1-deployed", f"{target_hostname=}"

      with subtest("Deploy to alice@target with passwordless sudo"):
        deployer.succeed("nixos-rebuild switch -I nixos-config=/root/configuration-2.nix --target-host alice@target --sudo &>/dev/console")
        target_hostname = deployer.succeed("ssh alice@target cat /etc/hostname").rstrip()
        assert target_hostname == "config-2-deployed", f"{target_hostname=}"

      with subtest("Deploy to bob@target with password based sudo"):
        # TODO: investigate why --ask-sudo-password from nixos-rebuild-ng is not working here
        deployer.succeed(r'NIX_SSHOPTS=-t passh -c 3 -C -p ${nodes.target.users.users.bob.password} -P "\[sudo\] password" nixos-rebuild switch -I nixos-config=/root/configuration-3.nix --target-host bob@target --sudo &>/dev/console')
        target_hostname = deployer.succeed("ssh alice@target cat /etc/hostname").rstrip()
        assert target_hostname == "config-3-deployed", f"{target_hostname=}"

      with subtest("Deploy works with very long TMPDIR"):
        tmp_dir = "/var/folder/veryveryveryveryverylongpathnamethatdoesnotworkwithcontrolpath"
        deployer.succeed(f"mkdir -p {tmp_dir}")
        deployer.succeed(f"TMPDIR={tmp_dir} nixos-rebuild switch -I nixos-config=/root/configuration-1.nix --target-host root@target &>/dev/console")
    '';
}
