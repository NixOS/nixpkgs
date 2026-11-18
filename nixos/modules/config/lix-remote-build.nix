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
                      The URI of the remote store in the format
                      `ssh[-ng]://[username@]hostname[?port=<port>]`, e.g. `ssh://nix@mac` or `ssh://mac`.
                      If the ssh server is not listening on port 22 (e.g. port 1337 in this case)
                      the URI would be `ssh[-ng]://nix@mac?port=1337`. The hostname
                      may be an alias defined in your `~/.ssh/config`.
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
                      A list of Nix platform type identifiers, such as
                      `x86_64-darwin`. It is possible for a machine to support multiple
                      platform types, e.g., `i686-linux` and `x86_64-linux`.

                    '';
                  };
                  ssh-key = mkOption {
                    type = types.nullOr types.path;
                    default = null;
                    example = "/root/.ssh/id_buildhost_builduser";
                    description = ''
                      The path to the SSH private key with which to authenticate on
                      the build machine. The private key must not have a passphrase.
                      If null, the building user (root on NixOS machines) must have an
                      appropriate ssh configuration to log in non-interactively.
                    '';
                  };
                  jobs = mkOption {
                    type = types.ints.u32;
                    default = 1;
                    description = ''
                      The maximum number of builds that Lix will execute in parallel on
                      the machine. Typically, this should be equal to the number of CPU
                      cores divided by the cores within the target machines configuration, i.e. `jobs * cores ~= cpu cores`
                    '';
                  };
                  speed-factor = mkOption {
                    type = types.numbers.positive;
                    default = 1;
                    description = ''
                      The “speed factor”, indicating the relative speed of the machine. If
                      there are multiple machines of the right type, Lix will prefer the
                      fastest, taking load into account.
                    '';
                  };
                  mandatory-features = mkOption {
                    type = types.nullOr (types.listOf types.str);
                    default = null;
                    example = [ "big-parallel" ];
                    description = ''
                      A list of *mandatory features*. A machine will only
                      be used to build a derivation if all the machine’s mandatory
                      features appear in the derivation’s `requiredSystemFeatures`
                      attribute.
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
                      A list of *supported features*. If a derivation has
                      the `requiredSystemFeatures` attribute, then Lix will only schedule
                      the derivation on a machine that has the specified features. For
                      example, the attribute

                      ```nix
                      requiredSystemFeatures = [ "kvm" ];
                      ```

                      will cause the build to be performed on a machine that has the `kvm`
                      feature.
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
