{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.vintagestory;
in
{
  options.services.vintagestory = {
    enable = lib.mkEnableOption "Vintagestory server";
    package = lib.mkPackageOption pkgs "vintagestory" { };

    openFirewall = lib.mkOption {
      description = "open the firewall on the specified port";
      default = false;
      type = lib.types.bool;
    };

    host = lib.mkOption {
      description = "The address that the server will bind to";
      default = null;
      example = "127.0.0.1";
      type = with lib.types; nullOr singleLineStr;
    };

    port = lib.mkOption {
      description = "The port that the server will bind to";
      default = 42420;
      type = lib.types.port;
    };

    maxClients = lib.mkOption {
      description = "The maximum amount of players that are allowed to join";
      default = 16;
      type = lib.types.int;
    };

    dataPath = lib.mkOption {
      description = "The path under /var/lib to store the server's state in";
      default = "vintagestory";
      example = "vintagestory-2";
      type = lib.types.str;
    };

    extraFlags = lib.mkOption {
      description = "Extra flags to pass to the server";
      default = [ ];
      type = with lib.types; listOf str;
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.vintagestory = { };

    users.users.vintagestory = {
      isSystemUser = true;
      group = "vintagestory";
    };

    systemd.services.vintagestory = {
      description = "Vintagestory server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      script =
        let
          # NOTE: casing is inconsistent in the server CLI, so this is
          # intentional
          opts = {
            inherit (cfg) port;
            dataPath = "/var/lib/${cfg.dataPath}";
            ip = cfg.host;
            maxclients = builtins.toString cfg.maxClients;
          };
        in
        ''
          ${lib.getExe' cfg.package "vintagestory-server"} \
            ${lib.cli.toGNUCommandLineShell { } opts} \
            ${lib.concatStringsSep " " cfg.extraFlags}
        '';

      serviceConfig = {
        StateDirectory = cfg.dataPath;

        User = "vintagestory";
        Group = "vintagestory";

        Sockets = "vintagestory.socket";
        # HACK: can't send all three over the same socket, because the
        # vintagestory server doesn't seem to support it
        StandardInput = "socket";
        StandardOutput = "journal";
        StandardError = "journal";

        Restart = "on-failure";
        RestartSec = 10;
        StartLimitBurst = 5;
      };
    };

    systemd.sockets.vintagestory = {
      description = "Command input for Vintagestory server";
      socketConfig = {
        ListenFIFO = "%t/vintagestory.socket";
        Service = "vintagestory.service";
      };
    };

    environment.systemPackages = [
      # HACK: read from the journal and pipe stdin to the socket at the same
      # time, to circumvent vintagestory limitations
      # At the moment this script is also the only way to make a player an
      # operator
      (pkgs.writeShellScriptBin "vintagestory-admin" ''
        journalctl -o cat -fu vintagestory.service & pid=$!
        ${lib.getExe pkgs.socat} -u STDIN PIPE:/run/vintagestory.socket

        kill $pid
      '')
    ];

    networking.firewall.allowedUDPPorts = lib.optional cfg.openFirewall cfg.port;
    networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall cfg.port;
  };

  meta.maintainers = with lib.maintainers; [ dtomvan ];
}
