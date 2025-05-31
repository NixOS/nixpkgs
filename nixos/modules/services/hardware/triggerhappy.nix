{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.triggerhappy;

  socket = "/run/thd.socket";

  configFile = pkgs.writeText "triggerhappy.conf" ''
    ${lib.concatMapStringsSep "\n" (
      {
        keys,
        event,
        cmd,
        ...
      }:
      ''${lib.concatMapStringsSep "+" (x: "KEY_" + x) keys} ${
        toString
          {
            press = 1;
            hold = 2;
            release = 0;
          }
          .${event}
      } ${cmd}''
    ) cfg.bindings}
    ${cfg.extraConfig}
  '';

  bindingCfg =
    { ... }:
    {
      options = {

        keys = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "List of keys to match.  Key names as defined in linux/input-event-codes.h";
        };

        event = lib.mkOption {
          type = lib.types.enum [
            "press"
            "hold"
            "release"
          ];
          default = "press";
          description = "Event to match.";
        };

        cmd = lib.mkOption {
          type = lib.types.str;
          description = "What to run.";
        };

      };
    };

in

{

  ###### interface

  options = {

    services.triggerhappy = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable the {command}`triggerhappy` hotkey daemon.
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "nobody";
        example = "root";
        description = ''
          User account under which {command}`triggerhappy` runs.
        '';
      };

      bindings = lib.mkOption {
        type = lib.types.listOf (lib.types.submodule bindingCfg);
        default = [ ];
        example = lib.literalExpression ''
          [ { keys = ["PLAYPAUSE"];  cmd = "''${lib.getExe pkgs.mpc} -q toggle"; } ]
        '';
        description = ''
          Key bindings for {command}`triggerhappy`.
        '';
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Literal contents to append to the end of {command}`triggerhappy` configuration file.
        '';
      };

    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    systemd.sockets.triggerhappy = {
      description = "Triggerhappy Socket";
      wantedBy = [ "sockets.target" ];
      socketConfig.ListenDatagram = socket;
    };

    systemd.services.triggerhappy = {
      wantedBy = [ "multi-user.target" ];
      description = "Global hotkey daemon";
      documentation = [ "man:thd(1)" ];
      serviceConfig = {
        ExecStart = "${pkgs.triggerhappy}/bin/thd ${
          lib.optionalString (cfg.user != "root") "--user ${cfg.user}"
        } --socket ${socket} --triggers ${configFile} --deviceglob /dev/input/event*";
      };
    };

    services.udev.packages = lib.singleton (
      pkgs.writeTextFile {
        name = "triggerhappy-udev-rules";
        destination = "/etc/udev/rules.d/61-triggerhappy.rules";
        text = ''
          ACTION=="add", SUBSYSTEM=="input", KERNEL=="event[0-9]*", ATTRS{name}!="triggerhappy", \
            RUN+="${pkgs.triggerhappy}/bin/th-cmd --socket ${socket} --passfd --udev"
        '';
      }
    );

  };

}
