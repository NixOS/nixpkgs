# Shared scaffolding for the nixos-rebuild VM tests: a self-contained
# machine that can run `nixos-rebuild` offline against a configuration
# derived from its own, plus a helper to write that configuration.
{ hostPkgs, ... }:
{
  # TODO: remove overlay from  nixos/modules/profiles/installation-device.nix
  #        make it a _small package instead, then remove pkgsReadOnly = false;.
  node.pkgsReadOnly = false;

  nodes = {
    machine =
      { lib, pkgs, ... }:
      {
        imports = [
          ../../modules/profiles/installation-device.nix
          ../../modules/profiles/base.nix
        ];

        nix.settings = {
          substituters = lib.mkForce [ ];
          hashed-mirrors = null;
          connect-timeout = 1;
        };

        system.includeBuildDependencies = true;

        system.extraDependencies = [
          # Not part of the initial build apparently?
          pkgs.grub2
        ];

        system.switch.enable = true;

        virtualisation = {
          cores = 2;
          memorySize = 4096;
        };
      };
  };

  # Writes a configuration.nix for use inside the machine: `extraConfig` is
  # spliced into a configuration matching the machine's own, so that
  # `nixos-rebuild` can rebuild it without network access.
  _module.args.mkConfigFile =
    extraConfig:
    hostPkgs.writeText "configuration.nix" # nix
      ''
        { lib, pkgs, ... }: {
          imports = [
            ./hardware-configuration.nix
            <nixpkgs/nixos/modules/testing/test-instrumentation.nix>
          ];

          boot.loader.grub = {
            enable = true;
            device = "/dev/vda";
            forceInstall = true;
          };

          documentation.enable = false;

        ${extraConfig}
        }
      '';
}
