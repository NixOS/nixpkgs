# Non-module arguments
# These are separate from the module arguments to avoid implicit dependencies.
# This makes service modules self-contains, allowing mixing of Nixpkgs versions.
{ pkgs }:

# The module
{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption types;
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
      argv = lib.mkOption {
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
        example = "SIGHUP";
        description = ''
          Configures the reload signal to send to the service manager.
          Note: Setting this will set the respective setting for the type of notificationProtocol you want to use.
        '';
      };

      reloadCommand = mkOption {
        type = types.nullOr types.str;
        default =
          if (config.process.reloadSignal != null) then
            "${pkgs.coreutils}/bin/kill -${config.process.reloadSignal} $MAINPID"
          else
            null;
        example = lib.literalExpression "''${pkgs.coreutils}/bin/kill -HUP $MAINPID";

        description = ''
          Command for reloading this service.
        '';
      };
    };

    notificationProtocol = mkOption {
      type = types.enum [
        "none"
        "systemd"
        "s6"
      ];
      default = "none";

      description = ''
        Notification protocol you want to use.
      '';
    };
  };

  config.assertions = [
    {
      assertion = (config.process.reloadSignal && config.process.reloadCommand);
      message = "reloadSignal conflicts with reloadCommand. Please either use reloadSignal or reloadCommand.";
    }
  ];
}
