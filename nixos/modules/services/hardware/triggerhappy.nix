{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.triggerhappy;

  socket = "/run/thd.socket";

  configFile = pkgs.writeText "triggerhappy.conf" ''
    ${concatMapStringsSep "\n"
      ({ keys, event, cmd, ... }:
        ''${concatMapStringsSep "+" (x: "KEY_" + x) keys} ${toString { press = 1; hold = 2; release = 0; }.${event}} ${cmd}''
      )
      cfg.bindings}
    ${cfg.extraConfig}
  '';

  bindingCfg = { ... }: {
    options = {

      keys = mkOption {
        type = types.listOf types.str;
        description = lib.mdDoc "List of keys to match.  Key names as defined in linux/input-event-codes.h";
      };

      event = mkOption {
        type = types.enum ["press" "hold" "release"];
        default = "press";
        description = lib.mdDoc "Event to match.";
      };

      cmd = mkOption {
        type = types.str;
        description = lib.mdDoc "What to run.";
      };

    };
  };

in

{

  ###### interface

  options = {

    services.triggerhappy = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable the {command}`triggerhappy` hotkey daemon.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "nobody";
        example = "root";
        description = lib.mdDoc ''
          User account under which {command}`triggerhappy` runs.
        '';
      };

      bindings = mkOption {
        type = types.listOf (types.submodule bindingCfg);
        default = [];
        example = lib.literalExpression ''
          [ { keys = ["PLAYPAUSE"];  cmd = "''${pkgs.mpc-cli}/bin/mpc -q toggle"; } ]
        '';
        description = lib.mdDoc ''
          Key bindings for {command}`triggerhappy`.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc ''
          Literal contents to append to the end of {command}`triggerhappy` configuration file.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    systemd.sockets.triggerhappy = {
      description = "Triggerhappy Socket";
      wantedBy = [ "sockets.target" ];
      socketConfig.ListenDatagram = socket;
    };

    systemd.services.triggerhappy = {
      wantedBy = [ "multi-user.target" ];
      description = "Global hotkey daemon";
      serviceConfig = {
        ExecStart = "${pkgs.triggerhappy}/bin/thd ${optionalString (cfg.user != "root") "--user ${cfg.user}"} --socket ${socket} --triggers ${configFile} --deviceglob /dev/input/event*";
      };
    };

    services.udev.packages = lib.singleton (pkgs.writeTextFile {
      name = "triggerhappy-udev-rules";
      destination = "/etc/udev/rules.d/61-triggerhappy.rules";
      text = ''
        ACTION=="add", SUBSYSTEM=="input", KERNEL=="event[0-9]*", ATTRS{name}!="triggerhappy", \
          RUN+="${pkgs.triggerhappy}/bin/th-cmd --socket ${socket} --passfd --udev"
      '';
    });

  };

}
