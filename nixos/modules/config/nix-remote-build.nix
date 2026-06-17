/*
  Manages the remote build configuration, /etc/nix/machines

  See also
   - ./nix.nix
   - nixos/modules/services/system/nix-daemon.nix
*/
{ config, lib, ... }:

let
  inherit (lib)
    any
    concatStringsSep
    filter
    mkIf
    mkOption
    types
    ;

  cfg = config.nix;
in
{
  options = {
    nix = {
      buildMachines = mkOption {
        type = lib.types.listOf (
          lib.types.submoduleWith {
            modules = [ ./nix-remote-builder.nix ];
            specialArgs = {
              nixVersion = lib.getVersion cfg.package;
            };
          }
        );
        default = [ ];
        description = ''
          This option lists the machines to be used if distributed builds are
          enabled (see {option}`nix.distributedBuilds`).
          Nix will perform derivations on those machines via SSH by copying the
          inputs to the Nix store on the remote machine, starting the build,
          then copying the output back to the local Nix store.
        '';
      };

      distributedBuilds = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to distribute builds to the machines listed in
          {option}`nix.buildMachines`.
        '';
      };
    };
  };

  # distributedBuilds does *not* inhibit /etc/nix/machines generation; caller may
  # override that nix option.
  config = mkIf cfg.enable {
    assertions =
      let
        badMachine = m: m.system == null && m.systems == [ ];
      in
      [
        {
          assertion = !(any badMachine cfg.buildMachines);
          message = ''
            At least one system type (via <varname>system</varname> or
              <varname>systems</varname>) must be set for every build machine.
              Invalid machine specifications:
          ''
          + "      "
          + (concatStringsSep "\n      " (map (m: m.hostName) (filter badMachine cfg.buildMachines)));
        }
      ];

    # List of machines for distributed Nix builds
    environment.etc."nix/machines" = mkIf (cfg.buildMachines != [ ]) {
      text = lib.concatMapStringsSep "\n" (bm: bm.rendered) cfg.buildMachines;
    };

    # Legacy configuration conversion.
    nix.settings = mkIf (!cfg.distributedBuilds) { builders = null; };
  };
}
