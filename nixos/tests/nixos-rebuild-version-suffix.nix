{ hostPkgs, ... }:
{
  name = "nixos-rebuild-version-suffix";

  # The installation-device profile uses an overlay.
  node.pkgsReadOnly = false;

  nodes.machine =
    { lib, pkgs, ... }:
    {
      imports = [
        ../modules/profiles/installation-device.nix
        ../modules/profiles/base.nix
      ];

      nix.enable = true;
      nix.settings = {
        substituters = lib.mkForce [ ];
        hashed-mirrors = null;
        connect-timeout = 1;
      };

      environment.systemPackages = [ pkgs.gitMinimal ];
      system.includeBuildDependencies = true;
      system.extraDependencies = [ pkgs.grub2 ];
      system.switch.enable = true;

      virtualisation = {
        cores = 2;
        memorySize = 4096;
        diskSize = 8192;
      };
    };

  testScript =
    let
      configFile = hostPkgs.writeText "configuration.nix" ''
        { pkgs, ... }: {
          imports = [
            ./hardware-configuration.nix
            <nixpkgs/nixos/modules/testing/test-instrumentation.nix>
          ];

          boot.loader.grub = {
            enable = true;
            device = "/dev/vda";
          };

          documentation.enable = false;
          environment.systemPackages = [ pkgs.gitMinimal ];
        }
      '';
    in
    # python
    ''
      import json

      machine.start()
      machine.wait_for_unit("multi-user.target")
      machine.succeed("udevadm settle")
      machine.succeed("nixos-generate-config")
      machine.copy_from_host("${configFile}", "/etc/nixos/configuration.nix")

      machine.succeed('cp -r "$(readlink -f "$(nix-instantiate --find-file nixpkgs)")" /root/nixpkgs')
      machine.succeed("chmod -R u+w /root/nixpkgs")
      machine.succeed("rm -f /root/nixpkgs/.version-suffix")
      machine.succeed("git -C /root/nixpkgs init")
      # Only track a fixture, so Git does not need to index the entire source tree.
      machine.succeed("echo clean > /root/nixpkgs/version-test")
      machine.succeed("git -C /root/nixpkgs add version-test")
      machine.succeed("git -C /root/nixpkgs -c user.name=test -c user.email=test@example.org commit -m initial")
      revision = machine.succeed("git -C /root/nixpkgs rev-parse --short HEAD").strip()

      with subtest("Use the Git revision as the version suffix"):
          machine.succeed("nixos-rebuild test --no-flake --no-reexec -I nixpkgs=/root/nixpkgs")
          version = json.loads(machine.succeed("nixos-version --json"))
          assert version["nixosVersion"].endswith(f".git.{revision}"), version
          machine.succeed("test ! -e /root/nixpkgs/.version-suffix")

      with subtest("Include the dirty marker in the version suffix"):
          machine.succeed("echo dirty > /root/nixpkgs/version-test")
          machine.succeed("nixos-rebuild test --no-flake --no-reexec -I nixpkgs=/root/nixpkgs")
          version = json.loads(machine.succeed("nixos-version --json"))
          assert version["nixosVersion"].endswith(f".git.{revision}M"), version
          machine.succeed("test ! -e /root/nixpkgs/.version-suffix")
    '';
}
