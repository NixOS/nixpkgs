{
  config,
  lib,
  pkgs,
  ...
}:
let
  json = pkgs.formats.json { };
  transitionType =
    with lib;
    types.submodule {
      freeformType = json.type;
      options.type = mkOption {
        type = types.enum [
          "delay"
          "event"
          "exec"
        ];
        description = ''
          Type of transition. Determines how bonsaid interprets the other options in this transition.
        '';
      };
      options.command = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
        description = ''
          Command to run when this transition is taken.
          This is executed inline by `bonsaid` and blocks handling of any other events until completion.
          To perform the command asynchronously, specify it like `[ "setsid" "-f" "my-command" ]`.

          Only effects transitions with `type = "exec"`.
        '';
      };
      options.delay_duration = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
          Nanoseconds to wait after the previous state change before performing this transition.
          This can be placed at the same level as a `type = "event"` transition to achieve a
          timeout mechanism.

          Only effects transitions with `type = "delay"`.
        '';
      };
      options.event_name = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Name of the event which should trigger this transition when received by `bonsaid`.
          Events are sent to `bonsaid` by running `bonsaictl -e <event_name>`.

          Only effects transitions with `type = "event"`.
        '';
      };
      options.transitions = mkOption {
        type = types.listOf transitionType;
        default = [ ];
        description = ''
          List of transitions out of this state.
          If left empty, then this state is considered a terminal state and entering it will
          trigger an immediate transition back to the root state (after processing side effects).
        '';
        visible = "shallow";
      };
    };
  cfg = config.services.bonsaid;
in
{
  meta.maintainers = with lib.maintainers; [ colinsane ];
  meta.buildDocsInSandbox = false;

  options.services.bonsaid = with lib; {
    enable = mkEnableOption "bonsaid";
    package = mkPackageOption pkgs "bonsai" { };
    extraFlags = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Extra flags to pass to `bonsaid`, such as `[ "-v" ]` to enable verbose logging.
      '';
    };
    settings = mkOption {
      type = types.listOf transitionType;
      default = [ ];
      description = ''
        State transition definitions. See the upstream [[README]](https://git.sr.ht/~stacyharper/bonsai)
        for extended documentation and a more complete example.
      '';
      example = [
        {
          type = "event";
          event_name = "power_button_pressed";
          transitions = [
            {
              # Hold power button for 600ms to trigger a command
              type = "delay";
              delay_duration = 600000000;
              transitions = [
                {
                  type = "exec";
                  command = [
                    "swaymsg"
                    "--"
                    "output"
                    "*"
                    "power"
                    "off"
                  ];
                  # `transitions = []` marks this as a terminal state,
                  # so bonsai will return to the root state immediately after executing the above command.
                  transitions = [ ];
                }
              ];
            }
            {
              # If the power button is released before the 600ms elapses, return to the root state.
              type = "event";
              event_name = "power_button_released";
              transitions = [ ];
            }
          ];
        }
      ];
    };
    settingsFile = mkOption {
      type = types.path;
      default =
        let
          filterNulls =
            v:
            if lib.isAttrs v then
              lib.mapAttrs (_: filterNulls) (lib.filterAttrs (_: a: a != null) v)
            else if lib.isList v then
              lib.map filterNulls (lib.filter (a: a != null) v)
            else
              v;
        in
        json.generate "bonsai_tree.json" (filterNulls cfg.settings);
      description = ''
        Path to a .json file specifying the state transitions.
        You don't need to set this unless you prefer to provide the json file
        yourself instead of using the `settings` option.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.bonsaid = {
      description = "Bonsai Finite State Machine daemon";
      unitConfig.Documentation = [ "https://git.sr.ht/~stacyharper/bonsai" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = lib.escapeShellArgs (
          [
            (lib.getExe' cfg.package "bonsaid")
            "-t"
            cfg.settingsFile
          ]
          ++ cfg.extraFlags
        );
        Type = "simple";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };
  };
}
