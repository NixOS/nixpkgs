/*
  Manages the remote build configuration toml as designed by lix, /etc/nix/machines.toml

  See also
   - ./nix.nix
   - nixos/modules/services/system/nix-daemon.nix
*/
{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    any
    concatMapStrings
    concatStringsSep
    filter
    getVersion
    mkIf
    mkOption
    optional
    optionalString
    types
    versionAtLeast
    ;

  cfg = config.lix;

  format = pkgs.formats.toml { };
  configFile = format.generate "machines.toml" (
    lib.filterAttrsRecursive (_: v: v != null) cfg.buildMachines
  );

in
{
  meta.maintainers = with lib.maintainers; [ rootile ];
  options = {
    lix.buildMachines = lib.mkOption {
      default = { };
      description = ''
        Lix TOML configuration for remote builders
      '';
      type = types.submodule {
        options = {
          version = mkOption {
            type = types.int;
            default = 1;
            example = 2;
            description = ''
              version of the TOML format.
            '';
            internal = true;
          };
          machines = mkOption {
            type = types.attrsOf (
              types.submodule {
                freeformType = format.type;
                options = {
                  uri = mkOption {
                    type = types.str;
                    example = "ssh-ng://andesite@andesite.lix.systems";
                    description = ''
                      store uri of the remote builder.
                    '';
                  };
                  system-types = mkOption {
                    type = types.nullOr (types.listOf types.str);
                    default = null;
                    example = [
                      "x86_64-linux"
                      "aarch64-linux"
                    ];
                    description = ''
                      The system types the build machine can execute derivations on.
                      Either this attribute or {var}`system` must be
                      present, where {var}`system` takes precedence if
                      both are set.
                    '';
                  };
                  ssh-key = mkOption {
                    type = types.nullOr types.str;
                    default = null;
                    example = "/root/.ssh/id_buildhost_builduser";
                    description = ''
                      The path to the SSH private key with which to authenticate on
                      the build machine. The private key must not have a passphrase.
                      If null, the building user (root on NixOS machines) must have an
                      appropriate ssh configuration to log in non-interactively.

                      Note that for security reasons, this path must point to a file
                      in the local filesystem, *not* to the nix store.
                    '';
                  };
                  jobs = mkOption {
                    type = types.int;
                    default = 1;
                    description = ''
                      The number of concurrent jobs the build machine supports. The
                      build machine will enforce its own limits, but this allows hydra
                      to schedule better since there is no work-stealing between build
                      machines.
                    '';
                  };
                  speed-factor = mkOption {
                    type = types.int;
                    default = 1;
                    description = ''
                      The relative speed of this builder. This is an arbitrary integer
                      that indicates the speed of this builder, relative to other
                      builders. Higher is faster.
                    '';
                  };
                  mandatory-features = mkOption {
                    type = types.nullOr (types.listOf types.str);
                    default = null;
                    example = [ "big-parallel" ];
                    description = ''
                      A list of features mandatory for this builder. The builder will
                      be ignored for derivations that don't require all features in
                      this list. All mandatory features are automatically included in
                      {var}`supportedFeatures`.
                    '';
                  };
                  supported-features = mkOption {
                    type = types.nullOr (types.listOf types.str);
                    default = null;
                    example = [
                      "kvm"
                      "big-parallel"
                    ];
                    description = ''
                      A list of features supported by this builder. The builder will
                      be ignored for derivations that require features not in this
                      list.
                    '';
                  };
                  ssh-public-host-key = mkOption {
                    type = types.nullOr types.str;
                    default = null;
                    description = ''
                      The public host key of this builder.
                      If null, SSH will use its regular known-hosts file when connecting.
                    '';
                  };
                  enable = mkOption {
                    type = types.bool;
                    default = true;
                    description = ''
                      Whether to enable this machine statically.
                    '';
                  };
                };
              }
            );
            default = { };
            description = ''
              This option lists the machines to be used if distributed builds are
              enabled (see {option}`nix.distributedBuilds`).
              Nix will perform derivations on those machines via SSH by copying the
              inputs to the Nix store on the remote machine, starting the build,
              then copying the output back to the local Nix store.
            '';
          };
        };
        freeformType = format.type;
      };
    };
  };

  config = mkIf (config.nix.enable && cfg.buildMachines.machines != { }) {
    assertions =
      let
        badMachine = m: m.system-types == null || m.system-types == [ ];
      in
      [
        {
          assertion = !(any badMachine (builtins.attrValues cfg.buildMachines.machines));
          message = ''
            At least one system type (via `system-types`) must be set for every build machine.
              Invalid machine specifications:
          ''
          + "      "
          + (concatStringsSep "\n      " (
            builtins.attrNames (lib.filterAttrs (_: badMachine) cfg.buildMachines.machines)
          ));
        }
        {
          assertion = config.nix.package.pname == "lix";
          message = ''
            TOML configuration of remote builders is only supported in lix.
          '';
        }
        {
          assertion = lib.versionAtLeast config.nix.package.version "2.95";
          message = ''
            TOML configuration was introduced in lix 2.95.0. Current version is ${config.nix.package.version}
          '';
        }
        {
          assertion = config.nix.buildMachines == [ ];
          message = ''
            mix-matching between lix and nix build machines is not supported.
          '';
        }
      ];

    nix.settings.builders = "@${configFile}";
  };
}
