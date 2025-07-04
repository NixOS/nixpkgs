{
  config,
  lib,
  pkgs,
  ...
}:
let
  json = pkgs.formats.json { };
  transitionType = lib.types.submodule {
    freeformType = json.type;
    options.type = lib.mkOption {
      type = lib.types.enum [
        "delay"
        "event"
        "exec"
      ];
      description = ''
        Type of transition. Determines how bonsaid interprets the other options in this transition.
      '';
    };
    options.command = lib.mkOption {
      type = lib.types.nullOr (lib.types.listOf lib.types.str);
      default = null;
      description = ''
        Command to run when this transition is taken.
        This is executed inline by `bonsaid` and blocks handling of any other events until completion.
        To perform the command asynchronously, specify it like `[ "setsid" "-f" "my-command" ]`.

        Only effects transitions with `type = "exec"`.
      '';
    };
    options.delay_duration = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = ''
        Nanoseconds to wait after the previous state change before performing this transition.
        This can be placed at the same level as a `type = "event"` transition to achieve a
        timeout mechanism.

        Only effects transitions with `type = "delay"`.
      '';
    };
    options.event_name = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Name of the event which should trigger this transition when received by `bonsaid`.
        Events are sent to `bonsaid` by running `bonsaictl -e <event_name>`.

        Only effects transitions with `type = "event"`.
      '';
    };
    options.transitions = lib.mkOption {
      type = lib.types.listOf transitionType;
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
  meta.maintainers = [ lib.maintainers.colinsane ];

  options.services.bonsaid = {
    enable = lib.mkEnableOption "bonsaid";
    package = lib.mkPackageOption pkgs "bonsai" { };
    extraFlags = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Extra flags to pass to `bonsaid`, such as `[ "-v" ]` to enable verbose logging.
      '';
    };
    settings = lib.mkOption {
      type = lib.types.listOf transitionType;
      description = ''
        State transition definitions. See the upstream [README](https://git.sr.ht/~stacyharper/bonsai)
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
    configFile = lib.mkOption {
      type = lib.types.path;
      description = ''
        Path to a .json file specifying the state transitions.
        You don't need to set this unless you prefer to provide the json file
        yourself instead of using the `settings` option.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.bonsaid.configFile =
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
      lib.mkDefault (json.generate "bonsai_tree.json" (filterNulls cfg.settings));

    # bonsaid is controlled by bonsaictl, so place the latter in the environment by default.
    # bonsaictl is typically invoked by scripts or a DE so this isn't strictly necessary,
    # but it's helpful while administering the service generally.
    environment.systemPackages = [ cfg.package ];

    systemd.user.services.bonsaid = {
      description = "Bonsai Finite State Machine daemon";
      documentation = [ "https://git.sr.ht/~stacyharper/bonsai" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = lib.escapeShellArgs (
          [
            (lib.getExe' cfg.package "bonsaid")
            "-t"
            cfg.configFile
          ]
          ++ cfg.extraFlags
        );
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };
  };
}
