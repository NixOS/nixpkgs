{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.p2pool;
in

{
  options = {
    services.p2pool = {
      enable = lib.mkEnableOption "Monero P2Pool node daemon";

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/p2pool";
        description = ''
          The directory where p2pool stores its data files.
        '';
      };

      sidechain = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "mini"
            "nano"
          ]
        );
        default = null;
        description = ''
          Which sidechain to mine on. (null for Main, "mini" or "nano" for the Mini and Nano chains.)
        '';
      };

      package = lib.mkPackageOption pkgs "p2pool" { };

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = ''
          The IP address of your Monero node.
        '';
      };

      logLevel = lib.mkOption {
        type = lib.types.ints.between 0 6;
        default = 2;
        description = ''
          Log level for the P2Pool node. (Between 0 - 6)
        '';
      };

      rpcPort = lib.mkOption {
        type = lib.types.port;
        default = 18081;
        description = ''
          Monero daemon RPC API port.
        '';
      };

      zmqPort = lib.mkOption {
        type = lib.types.port;
        default = 18083;
        description = ''
          Monero daemon ZMQ pub port.
        '';
      };

      socks5 = {
        enable = lib.mkEnableOption "connecting to a SOCKS5 proxy for outgoing connections";

        ip = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
          description = ''
            IP address of the SOCKS5 proxy to connect to.
          '';
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 9050;
          description = ''
            The port number of the SOCKS5 proxy.
          '';
        };
      };

      walletAddress = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          The Monero wallet address used for mining payouts.
          It's recommended to store your wallet address in an environment file to avoid it being saved in the nix store.
          See [](#opt-services.p2pool.environmentFile) for more details.
        '';
      };

      extraArgs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [
          "--out-peers 12"
          "--in-peers 8"
        ];
        description = ''
          List of extra command-line arguments to be passed to the P2Pool daemon.
        '';
      };

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/var/lib/p2pool/p2pool.env";
        description = ''
          Path to an EnvironmentFile for the p2pool service as defined in {manpage}`systemd.exec(5)`.

          Secrets may be passed to the service by specifying placeholder variables in the Nix config
          and setting values in the environment file.

          Example:

          ```
          # In environment file:
          WALLET_ADDRESS=888tNkZrPN6JsEgekjMnABU4TBzc2Dt29EPAvkRxbANsAnjyPbb3iQ1YBRk1UXcdRsiKc9dhwMVgN5S9cQUiyoogDavup3H
          ```

          ```
          # Service config
          services.p2pool.walletAddress = "$WALLET_ADDRESS";
          ```
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = lib.singleton {
      assertion = cfg.walletAddress != "";
      message = ''
        A wallet address must be specified.
        It's recommended to set `services.p2pool.walletAddress` to an environment variable of your choosing and provide
        a filepath to `services.p2pool.environmentFile` with the corresponding variable and value.
      '';
    };

    users.users.p2pool = {
      isSystemUser = true;
      group = "p2pool";
      description = "P2Pool node user";
      home = cfg.dataDir;
      createHome = true;
    };

    users.groups.p2pool = { };

    systemd.sockets.p2pool = {
      description = "P2Pool Command Socket";
      socketConfig = {
        SocketUser = "p2pool";
        SocketGroup = "p2pool";
        ListenFIFO = "/run/p2pool/p2pool.control";
        RemoveOnStop = true;
        DirectoryMode = "0755";
        SocketMode = "0666";
      };
    };

    systemd.services.p2pool = {
      description = "P2Pool node";
      after = [
        "network.target"
        "system-modules-load.target"
      ];
      wants = [
        "network.target"
        "system-modules-load.target"
      ];
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${lib.getExe cfg.package} \
          --data-dir ${cfg.dataDir} \
          --rpc-port ${toString cfg.rpcPort} \
          --zmq-port ${toString cfg.zmqPort} \
          --host ${cfg.host} \
      ''
      + "--loglevel ${toString cfg.logLevel}"
      + "${lib.optionalString (cfg.sidechain == "mini") " \\\n --mini"}"
      + "${lib.optionalString (cfg.sidechain == "nano") " \\\n --nano"}"
      + "${lib.optionalString cfg.socks5.enable " \\\n--socks5 ${cfg.socks5.ip}:${toString cfg.socks5.port}"}"
      + "${lib.optionalString (cfg.walletAddress != "") " \\\n--wallet ${cfg.walletAddress}"}"
      + lib.optionalString (cfg.extraArgs != [ ]) (lib.strings.concatStringsSep " \\\n" cfg.extraArgs);

      serviceConfig = {
        Type = "exec";
        User = "p2pool";
        Group = "p2pool";
        Restart = "always";
        WorkingDirectory = cfg.dataDir;
        TimeoutStop = 60;

        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];

        StandardInput = "socket";
        StandardOutput = "journal";
        StandardError = "journal";

        Sockets = [ "p2pool.socket" ];

        ProtectSystem = "full";
        ProtectHome = true;
        PrivateTmp = "disconnected";
        PrivateDevices = true;
        PrivateMounts = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        ProtectProc = "ptraceable";
        ProcSubset = "pid";
        LockPersonality = true;
        RestrictRealtime = true;
        ProtectClock = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
          "AF_UNIX"
        ];
        SocketBindDeny = [
          "ipv4:udp"
          "ipv6:udp"
        ];
        CapabilityBoundingSet = [
          "~CAP_BLOCK_SUSPEND"
          "CAP_BPF"
          "CAP_CHOWN"
          "CAP_MKNOD"
          "CAP_NET_RAW"
          "CAP_PERFMON"
          "CAP_SYS_BOOT"
          "CAP_SYS_CHROOT"
          "CAP_SYS_MODULE"
          "CAP_SYS_PACCT"
          "CAP_SYS_PTRACE"
          "CAP_SYS_TIME"
          "CAP_SYSLOG"
          "CAP_WAKE_ALARM"
        ];
        SystemCallFilter = [
          "~@chown:EPERM"
          "@clock:EPERM"
          "@cpu-emulation:EPERM"
          "@debug:EPERM"
          "@keyring:EPERM"
          "@memlock:EPERM"
          "@module:EPERM"
          "@mount:EPERM"
          "@obsolete:EPERM"
          "@pkey:EPERM"
          "@privileged:EPERM"
          "@raw-io:EPERM"
          "@reboot:EPERM"
          "@sandbox:EPERM"
          "@setuid:EPERM"
          "@swap:EPERM"
          "@timer:EPERM"
        ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    JacoMalan1
    jk
  ];
}
