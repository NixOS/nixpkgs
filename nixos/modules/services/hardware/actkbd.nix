{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.actkbd;

  isUserBindings = bool:
    builtins.filter (a: a.userMode == bool) cfg.bindings;

  mkConfigFile = isUser:
    pkgs.writeText "actkbd.conf" ''
    ${concatMapStringsSep "\n"
      ({ keys, events, attributes, command, ... }:
        ''${concatMapStringsSep "+" toString keys}:${concatStringsSep "," events}:${concatStringsSep "," attributes}:${command}''
      )
      ( isUserBindings isUser )}
      ${cfg.extraConfig}'';

  mkSystemdService = config:
  {
    enable = true;
    restartIfChanged = true;
    unitConfig = {
      Description = "actkbd on %I";
      ConditionPathExists = "%I";
    };
    serviceConfig = {
      Type = "forking";
      ExecStart = "${pkgs.actkbd}/bin/actkbd -D -c ${config} -d %I";
    };
  };

  bindingCfg = { ... }: {
    options = {

      userMode = mkOption {
        type = types.bool;
        default = false;
        description = ''
          whether to deploy this binding as a systemd user service; useful for
          some programs which require user privileges. This is rarely needed and
          should only be enabled if it is absolutely required.

          E.g. <option>sound.mediaKeys</option> enables this when <option>hardware.pulseaudio.enable</option> is set.
          '';
      };

      keys = mkOption {
        type = types.listOf types.int;
        description = "List of keycodes to match.";
      };

      events = mkOption {
        type = types.listOf (types.enum ["key" "rep" "rel"]);
        default = [ "key" ];
        description = "List of events to match.";
      };

      attributes = mkOption {
        type = types.listOf types.str;
        default = [ "exec" ];
        description = "List of attributes.";
      };

      command = mkOption {
        type = types.str;
        default = "";
        description = "What to run.";
      };

    };
  };

in

{

  ###### interface

  options = {

    services.actkbd = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the <command>actkbd</command> key mapping daemon.

          Turning this on will start an <command>actkbd</command>
          instance for every evdev input that has at least one key
          (which is okay even for systems with tiny memory footprint,
          since actkbd normally uses &lt;100 bytes of memory per
          instance).

          This allows binding keys globally without the need for e.g.
          X11.
        '';
      };

      bindings = mkOption {
        type = types.listOf (types.submodule bindingCfg);
        default = [];
        example = lib.literalExample ''
          [ { keys = [ 113 ]; events = [ "key" ]; command = "''${pkgs.alsaUtils}/bin/amixer -q set Master toggle"; }
          ]
        '';
        description = ''
          Key bindings for <command>actkbd</command>.

          See <command>actkbd</command> <filename>README</filename> for documentation.

          The example shows a piece of what <option>sound.enableMediaKeys</option> does when enabled.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Literal contents to append to the end of actkbd configuration file.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.udev.packages = lib.singleton (pkgs.writeTextFile {
      name = "actkbd-udev-rules";
      destination = "/etc/udev/rules.d/61-actkbd.rules";
      text = let actkbdVar = "actkbd@$env{DEVNAME}.service";
      in ''
        ACTION=="add" \
        , SUBSYSTEM=="input" \
        , KERNEL=="event[0-9]*" \
        , ENV{ID_INPUT_KEY}=="1" \
        , TAG+="systemd" \
        , ENV{SYSTEMD_WANTS}+="${actkbdVar}" \
        , ENV{SYSTEMD_USER_WANTS}+="${actkbdVar}"
      '';
    });

    systemd.services = mkIf ( isUserBindings false != [] )
    { "actkbd@" = ( mkSystemdService (mkConfigFile false) );
    };

    systemd.user = mkIf ( isUserBindings true != [] )
    { services."actkbd@" = mkSystemdService (mkConfigFile true);

      # this is needed because input devices initialize at boot and systemd
      # only starts device dependant services on their initialization
      services."start-actkbd" =
      { enable = true;
        unitConfig =
        { Description = "user instances of actkbd";
          Type = "idle";
        };
        script =
          "${pkgs.systemd}/bin/systemctl --user start 'actkbd@*.service' --all";
        wantedBy = [ "default.target" ];
      };
    };

    # For testing
    environment.systemPackages = [ pkgs.actkbd ];

  };

}
