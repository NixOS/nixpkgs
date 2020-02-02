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
        description = "List of keys to match.  Key names as defined in linux/input-event-codes.h";
      };

      event = mkOption {
        type = types.enum ["press" "hold" "release"];
        default = "press";
        description = "Event to match.";
      };

      cmd = mkOption {
        type = types.str;
        description = "What to run.";
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
        description = ''
          Whether to enable the <command>triggerhappy</command> hotkey daemon.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "nobody";
        example = "root";
        description = ''
          User account under which <command>triggerhappy</command> runs.
        '';
      };

      bindings = mkOption {
        type = types.listOf (types.submodule bindingCfg);
        default = [];
        example = lib.literalExample ''
          [ { keys = ["PLAYPAUSE"];  cmd = "''${pkgs.mpc_cli}/bin/mpc -q toggle"; } ]
        '';
        description = ''
          Key bindings for <command>triggerhappy</command>.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Literal contents to append to the end of <command>triggerhappy</command> configuration file.
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
