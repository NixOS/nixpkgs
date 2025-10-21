{
  lib,
  pkgs,
  config,
  extendModules,
  ...
}:
{

  options = {

    system.build = {
      noFacter = lib.mkOption {
        type = lib.types.unspecified;
        description = "A version of the system closure with facter disabled";
      };
    };

    hardware.facter.debug = {
      nvd = lib.mkOption {
        type = lib.types.package;
        description = ''
          A shell application which will produce an nvd diff of the system closure with and without facter enabled.
        '';
      };
      nix-diff = lib.mkOption {
        type = lib.types.package;
        description = ''
          A shell application which will produce a nix-diff of the system closure with and without facter enabled.
        '';
      };
    };

  };

  config.system.build = {
    noFacter = extendModules {
      modules = [
        {
          # we 'disable' facter by overriding the report and setting it to empty with one caveat: hostPlatform
          config.hardware.facter.report = lib.mkForce {
            system = config.nixpkgs.hostPlatform;
          };
        }
      ];
    };
  };

  config.hardware.facter.debug = {

    nvd = pkgs.writeShellApplication {
      name = "facter-nvd-diff";
      runtimeInputs = [
        config.nix.package
        pkgs.nvd
      ];
      text = ''
        nvd diff \
          ${config.system.build.noFacter.config.system.build.toplevel} \
          ${config.system.build.toplevel} \
          "$@"
      '';
    };

    nix-diff = pkgs.writeShellApplication {
      name = "facter-nix-diff";
      runtimeInputs = [
        config.nix.package
        pkgs.nix-diff
      ];
      text = ''
        nix-diff \
          ${config.system.build.noFacter.config.system.build.toplevel} \
          ${config.system.build.toplevel} \
          "$@"
      '';
    };

  };

}
