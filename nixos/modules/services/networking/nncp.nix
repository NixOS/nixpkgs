{
  config,
  lib,
  pkgs,
  ...
}:
with lib;

let
  nncpCfgFile = "/run/nncp.hjson";
  programCfg = config.programs.nncp;
  callerCfg = config.services.nncp.caller;
  daemonCfg = config.services.nncp.daemon;
  settingsFormat = pkgs.formats.json { };
  jsonCfgFile = settingsFormat.generate "nncp.json" programCfg.settings;
  pkg = programCfg.package;
in
{
  options = {

    services.nncp = {
      caller = {
        enable = mkEnableOption ''
          cron'ed NNCP TCP daemon caller.
          The daemon will take configuration from
          [](#opt-programs.nncp.settings)
        '';
        extraArgs = mkOption {
          type = with types; listOf str;
          description = "Extra command-line arguments to pass to caller.";
          default = [ ];
          example = [ "-autotoss" ];
        };
      };

      daemon = {
        enable = mkEnableOption ''
          NNCP TCP synronization daemon.
          The daemon will take configuration from
          [](#opt-programs.nncp.settings)
        '';
        socketActivation = {
          enable = mkEnableOption ''
            Whether to run nncp-daemon persistently or socket-activated.
          '';
          listenStreams = mkOption {
            type = with types; listOf str;
            description = ''
              TCP sockets to bind to.
              See [](#opt-systemd.sockets._name_.listenStreams).
            '';
            default = [ "5400" ];
          };
        };
        extraArgs = mkOption {
          type = with types; listOf str;
          description = "Extra command-line arguments to pass to daemon.";
          default = [ ];
          example = [ "-autotoss" ];
        };
      };

    };
  };

  config = mkIf (programCfg.enable or callerCfg.enable or daemonCfg.enable) {

    assertions = [
      {
        assertion =
          with builtins;
          let
            callerCongfigured =
              let
                neigh = config.programs.nncp.settings.neigh or { };
              in
              lib.lists.any (x: hasAttr "calls" x && x.calls != [ ]) (attrValues neigh);
          in
          !callerCfg.enable || callerCongfigured;
        message = "NNCP caller enabled but call configuration is missing";
      }
    ];

    systemd.services."nncp-caller" = {
      inherit (callerCfg) enable;
      description = "Croned NNCP TCP daemon caller.";
      documentation = [ "http://www.nncpgo.org/nncp_002dcaller.html" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''${pkg}/bin/nncp-caller -noprogress -cfg "${nncpCfgFile}" ${lib.strings.escapeShellArgs callerCfg.extraArgs}'';
        Group = "uucp";
        UMask = "0002";
      };
    };

    systemd.services."nncp-daemon" = mkIf daemonCfg.enable {
      enable = !daemonCfg.socketActivation.enable;
      description = "NNCP TCP syncronization daemon.";
      documentation = [ "http://www.nncpgo.org/nncp_002ddaemon.html" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''${pkg}/bin/nncp-daemon -noprogress -cfg "${nncpCfgFile}" ${lib.strings.escapeShellArgs daemonCfg.extraArgs}'';
        Restart = "on-failure";
        Group = "uucp";
        UMask = "0002";
      };
    };

    systemd.services."nncp-daemon@" = mkIf daemonCfg.socketActivation.enable {
      description = "NNCP TCP syncronization daemon.";
      documentation = [ "http://www.nncpgo.org/nncp_002ddaemon.html" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = ''${pkg}/bin/nncp-daemon -noprogress -ucspi -cfg "${nncpCfgFile}" ${lib.strings.escapeShellArgs daemonCfg.extraArgs}'';
        Group = "uucp";
        UMask = "0002";
        StandardInput = "socket";
        StandardOutput = "inherit";
        StandardError = "journal";
      };
    };

    systemd.sockets.nncp-daemon = mkIf daemonCfg.socketActivation.enable {
      inherit (daemonCfg.socketActivation) listenStreams;
      description = "socket for NNCP TCP syncronization.";
      conflicts = [ "nncp-daemon.service" ];
      wantedBy = [ "sockets.target" ];
      socketConfig.Accept = true;
    };
  };
}
