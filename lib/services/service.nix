# Non-module arguments
# These are separate from the module arguments to avoid implicit dependencies.
# This makes service modules self-contains, allowing mixing of Nixpkgs versions.
{ pkgs }:

# The module
{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption types;
  pathOrStr = types.coercedTo types.path (x: "${x}") types.str;
in
{
  # https://nixos.org/manual/nixos/unstable/#modular-services
  _class = "service";
  imports = [
    ../../modules/generic/meta-maintainers.nix
    ../../nixos/modules/misc/assertions.nix
    (lib.modules.importApply ./config-data.nix { inherit pkgs; })
  ];
  options = {
    services = mkOption {
      type = types.attrsOf (
        types.submoduleWith {
          modules = [
            (lib.modules.importApply ./service.nix { inherit pkgs; })
          ];
        }
      );
      description = ''
        A collection of [modular services](https://nixos.org/manual/nixos/unstable/#modular-services) that are configured in one go.

        You could consider the sub-service relationship to be an ownership relation.
        It **does not** automatically create any other relationship between services (e.g. systemd slices), unless perhaps such a behavior is explicitly defined and enabled in another option.
      '';
      default = { };
      visible = "shallow";
    };
    process = {
      argv = mkOption {
        type = types.listOf pathOrStr;
        example = lib.literalExpression ''[ (lib.getExe config.package) "--nobackground" ]'';
        description = ''
          Command filename and arguments for starting this service.
          This is a raw command-line that should not contain any shell escaping.
          If expansion of environmental variables is required then use
          a shell script or `importas` from `pkgs.execline`.
        '';
      };

      reloadSignal = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "HUP";
        description = ''
          Configures the reload signal to send to the service manager.
        '';
      };

      reloadCommand = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = lib.literalExpression ''"''${pkgs.coreutils}/bin/kill -HUP $MAINPID"'';

        description = ''
          Command used for reloading in the underlying service manager to reload.
        '';
      };

      environment = lib.mkOption {
        type = types.lazyAttrsOf (
          types.nullOr (types.coercedTo (types.either types.path types.package) (x: "${x}") types.str)
        );
        default = { };
        example = lib.literalExpression ''{ FOO = "bar"; PATH = null; }'';
        description = ''
          Environment variables passed verbatim to the service process by the
          service manager. Entries set to `null` actively unset the variable
          before the process starts -- backends without native unset support use
          a wrapper (e.g. `execline`'s `unexport`) so the variable is absent
          even when the service manager or a backend-specific override would
          otherwise supply it.

          Values appear in the rendered unit and may be world-readable. For
          secrets, use a backend-specific mechanism such as
          `systemd.service.serviceConfig.EnvironmentFile`.
        '';
      };
    };

    notificationProtocol = mkOption {
      type = types.submodule {
        options = {
          systemd = mkEnableOption "Whether the service supports systemd-notify.";
          s6 = mkEnableOption "Whether the service supports s6-notify.";
        };
      };
      description = ''
        Notification protocol that this service supports with the underlying service manager.
      '';
    };
  };

  config = {
    assertions = [
      {
        # `reloadSignal` derives `reloadCommand` at `mkDefault` priority below, so a
        # conflict only exists when the user *also* set `reloadCommand` explicitly.
        # An explicit (non-`mkDefault`) definition has `defaultOverridePriority`.
        assertion =
          !(
            config.process.reloadSignal != null
            && options.process.reloadCommand.highestPrio <= lib.modules.defaultOverridePriority
          );
        message = "reloadSignal conflicts with reloadCommand. Please either use reloadSignal or reloadCommand.";
      }
    ];

    process.reloadCommand = lib.mkIf (config.process.reloadSignal != null) (
      lib.mkDefault "${pkgs.coreutils}/bin/kill -${config.process.reloadSignal} $MAINPID"
    );
  };
}
