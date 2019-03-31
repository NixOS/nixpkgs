{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.actkbd;

  configFile = pkgs.writeText "actkbd.conf" ''
    ${concatMapStringsSep "\n"
      ({ keys, events, attributes, command, ... }:
        ''${concatMapStringsSep "+" toString keys}:${concatStringsSep "," events}:${concatStringsSep "," attributes}:${command}''
      )
      cfg.bindings}
    ${cfg.extraConfig}
  '';

  bindingCfg = { ... }: {
    options = {

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

          The example shows a piece of what <option>services.actkbd.volumeControl.enable</option> does when enabled.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Literal contents to append to the end of actkbd configuration file.
        '';
      };

      volumeControl = {

        enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Whether to enable ALSA volume and capture control with keyboard media keys.

            You want to leave this disabled if you run a desktop environment
            like KDE, Gnome, Xfce, etc, as those handle such things themselves.
            You might want to enable this if you run a minimalistic desktop
            environment or work from bare linux ttys/framebuffers.
          '';
        };

        step = mkOption {
          type = types.string;
          default = "1";
          example = "1%";
          description = ''
            The value by which to increment/decrement volume on media keys.

            See amixer(1) for allowed values.
          '';
        };

      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.udev.packages = lib.singleton (pkgs.writeTextFile {
      name = "actkbd-udev-rules";
      destination = "/etc/udev/rules.d/61-actkbd.rules";
      text = ''
        ACTION=="add", SUBSYSTEM=="input", KERNEL=="event[0-9]*", ENV{ID_INPUT_KEY}=="1", TAG+="systemd", ENV{SYSTEMD_WANTS}+="actkbd@$env{DEVNAME}.service"
      '';
    });

    systemd.services."actkbd@" = {
      enable = true;
      restartIfChanged = true;
      unitConfig = {
        Description = "actkbd on %I";
        ConditionPathExists = "%I";
      };
      serviceConfig = {
        Type = "forking";
        ExecStart = "${pkgs.actkbd}/bin/actkbd -D -c ${configFile} -d %I";
      };
    };

    # For testing
    environment.systemPackages = [ pkgs.actkbd ];

    services.actkbd.bindings = []
      ++ optionals cfg.volumeControl.enable [
        # "Mute" media key
        { keys = [ 113 ]; events = [ "key" ];       command = "${pkgs.alsaUtils}/bin/amixer -q set Master toggle"; }

        # "Lower Volume" media key
        { keys = [ 114 ]; events = [ "key" "rep" ]; command = "${pkgs.alsaUtils}/bin/amixer -q set Master ${cfg.volumeControl.step}- unmute"; }

        # "Raise Volume" media key
        { keys = [ 115 ]; events = [ "key" "rep" ]; command = "${pkgs.alsaUtils}/bin/amixer -q set Master ${cfg.volumeControl.step}+ unmute"; }

        # "Mic Mute" media key
        { keys = [ 190 ]; events = [ "key" ];       command = "${pkgs.alsaUtils}/bin/amixer -q set Capture toggle"; }
      ];

  };

}
