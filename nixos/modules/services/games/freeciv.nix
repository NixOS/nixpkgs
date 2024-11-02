{ config, lib, pkgs, ... }:
let
  cfg = config.services.freeciv;
  inherit (config.users) groups;
  rootDir = "/run/freeciv";
  argsFormat = {
    type = with lib.types; let
      valueType = nullOr (oneOf [
        bool int float str
        (listOf valueType)
      ]) // {
        description = "freeciv-server params";
      };
    in valueType;
    generate = name: value:
      let mkParam = k: v:
            if v == null then []
            else if lib.isBool v then lib.optional v ("--"+k)
            else [("--"+k) v];
          mkParams = k: v: map (mkParam k) (if lib.isList v then v else [v]);
      in lib.escapeShellArgs (lib.concatLists (lib.concatLists (lib.mapAttrsToList mkParams value)));
  };
in
{
  options = {
    services.freeciv = {
      enable = lib.mkEnableOption ''freeciv'';
      settings = lib.mkOption {
        description = ''
          Parameters of freeciv-server.
        '';
        default = {};
        type = lib.types.submodule {
          freeformType = argsFormat.type;
          options.Announce = lib.mkOption {
            type = lib.types.enum ["IPv4" "IPv6" "none"];
            default = "none";
            description = "Announce game in LAN using given protocol.";
          };
          options.auth = lib.mkEnableOption "server authentication";
          options.Database = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            apply = pkgs.writeText "auth.conf";
            default = ''
              [fcdb]
                backend="sqlite"
                database="/var/lib/freeciv/auth.sqlite"
            '';
            description = "Enable database connection with given configuration.";
          };
          options.debug = lib.mkOption {
            type = lib.types.ints.between 0 3;
            default = 0;
            description = "Set debug log level.";
          };
          options.exit-on-end = lib.mkEnableOption "exit instead of restarting when a game ends";
          options.Guests = lib.mkEnableOption "guests to login if auth is enabled";
          options.Newusers = lib.mkEnableOption "new users to login if auth is enabled";
          options.port = lib.mkOption {
            type = lib.types.port;
            default = 5556;
            description = "Listen for clients on given port";
          };
          options.quitidle = lib.mkOption {
            type = lib.types.nullOr lib.types.int;
            default = null;
            description = "Quit if no players for given time in seconds.";
          };
          options.read = lib.mkOption {
            type = lib.types.lines;
            apply = v: pkgs.writeTextDir "read.serv" v + "/read";
            default = ''
              /fcdb lua sqlite_createdb()
            '';
            description = "Startup script.";
          };
          options.saves = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = "/var/lib/freeciv/saves/";
            description = ''
              Save games to given directory,
              a sub-directory named after the starting date of the service
              will me inserted to preserve older saves.
            '';
          };
        };
      };
      openFirewall = lib.mkEnableOption "opening the firewall for the port listening for clients";
    };
  };
  config = lib.mkIf cfg.enable {
    users.groups.freeciv = {};
    # Use with:
    #   journalctl -u freeciv.service -f -o cat &
    #   cat >/run/freeciv.stdin
    #   load saves/2020-11-14_05-22-27/freeciv-T0005-Y-3750-interrupted.sav.bz2
    systemd.sockets.freeciv = {
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        ListenFIFO = "/run/freeciv.stdin";
        SocketGroup = groups.freeciv.name;
        SocketMode = "660";
        RemoveOnStop = true;
      };
    };
    systemd.services.freeciv = {
      description = "Freeciv Service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment.HOME = "/var/lib/freeciv";
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "5s";
        StandardInput = "fd:freeciv.socket";
        StandardOutput = "journal";
        StandardError = "journal";
        ExecStart = pkgs.writeShellScript "freeciv-server" (''
          set -eux
          savedir=$(date +%Y-%m-%d_%H-%M-%S)
          '' + "${pkgs.freeciv}/bin/freeciv-server"
          + " " + lib.optionalString (cfg.settings.saves != null)
            (lib.concatStringsSep " " [ "--saves" "${lib.escapeShellArg cfg.settings.saves}/$savedir" ])
          + " " + argsFormat.generate "freeciv-server" (cfg.settings // { saves = null; }));
        DynamicUser = true;
        # Create rootDir in the host's mount namespace.
        RuntimeDirectory = [(baseNameOf rootDir)];
        RuntimeDirectoryMode = "755";
        StateDirectory = [ "freeciv" ];
        WorkingDirectory = "/var/lib/freeciv";
        # Avoid mounting rootDir in the own rootDir of ExecStart='s mount namespace.
        InaccessiblePaths = ["-+${rootDir}"];
        # This is for BindPaths= and BindReadOnlyPaths=
        # to allow traversal of directories they create in RootDirectory=.
        UMask = "0066";
        RootDirectory = rootDir;
        RootDirectoryStartOnly = true;
        MountAPIVFS = true;
        BindReadOnlyPaths = [
          builtins.storeDir
          "/etc"
          "/run"
        ];
        # The following options are only for optimizing:
        # systemd-analyze security freeciv
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        # ProtectClock= adds DeviceAllow=char-rtc r
        DeviceAllow = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateNetwork = lib.mkDefault false;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallFilter = [
          "@system-service"
          # Groups in @system-service which do not contain a syscall listed by:
          # perf stat -x, 2>perf.log -e 'syscalls:sys_enter_*' freeciv-server
          # in tests, and seem likely not necessary for freeciv-server.
          "~@aio" "~@chown" "~@ipc" "~@keyring" "~@memlock"
          "~@resources" "~@setuid" "~@sync" "~@timer"
        ];
        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
      };
    };
    networking.firewall = lib.mkIf cfg.openFirewall
      { allowedTCPPorts = [ cfg.settings.port ]; };
  };
  meta.maintainers = with lib.maintainers; [ julm ];
}
