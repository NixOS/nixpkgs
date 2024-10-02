{ config, lib, pkgs, ... }:

let
  cfg     = config.services.monero;

  listToConf = option: list:
    lib.concatMapStrings (value: "${option}=${value}\n") list;

  login = (cfg.rpc.user != null && cfg.rpc.password != null);

  configFile = with cfg; pkgs.writeText "monero.conf" ''
    log-file=/dev/stdout
    data-dir=${dataDir}

    ${lib.optionalString mining.enable ''
      start-mining=${mining.address}
      mining-threads=${toString mining.threads}
    ''}

    rpc-bind-ip=${rpc.address}
    rpc-bind-port=${toString rpc.port}
    ${lib.optionalString login ''
      rpc-login=${rpc.user}:${rpc.password}
    ''}
    ${lib.optionalString rpc.restricted ''
      restricted-rpc=1
    ''}

    limit-rate-up=${toString limits.upload}
    limit-rate-down=${toString limits.download}
    max-concurrency=${toString limits.threads}
    block-sync-size=${toString limits.syncSize}

    ${listToConf "add-peer" extraNodes}
    ${listToConf "add-priority-node" priorityNodes}
    ${listToConf "add-exclusive-node" exclusiveNodes}

    ${extraConfig}
  '';

in

{

  ###### interface

  options = {

    services.monero = {

      enable = lib.mkEnableOption "Monero node daemon";

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/monero";
        description = ''
          The directory where Monero stores its data files.
        '';
      };

      mining.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to mine monero.
        '';
      };

      mining.address = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Monero address where to send mining rewards.
        '';
      };

      mining.threads = lib.mkOption {
        type = lib.types.addCheck lib.types.int (x: x>=0);
        default = 0;
        description = ''
          Number of threads used for mining.
          Set to `0` to use all available.
        '';
      };

      rpc.user = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          User name for RPC connections.
        '';
      };

      rpc.password = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Password for RPC connections.
        '';
      };

      rpc.address = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = ''
          IP address the RPC server will bind to.
        '';
      };

      rpc.port = lib.mkOption {
        type = lib.types.port;
        default = 18081;
        description = ''
          Port the RPC server will bind to.
        '';
      };

      rpc.restricted = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to restrict RPC to view only commands.
        '';
      };

      limits.upload = lib.mkOption {
        type = lib.types.addCheck lib.types.int (x: x>=-1);
        default = -1;
        description = ''
          Limit of the upload rate in kB/s.
          Set to `-1` to leave unlimited.
        '';
      };

      limits.download = lib.mkOption {
        type = lib.types.addCheck lib.types.int (x: x>=-1);
        default = -1;
        description = ''
          Limit of the download rate in kB/s.
          Set to `-1` to leave unlimited.
        '';
      };

      limits.threads = lib.mkOption {
        type = lib.types.addCheck lib.types.int (x: x>=0);
        default = 0;
        description = ''
          Maximum number of threads used for a parallel job.
          Set to `0` to leave unlimited.
        '';
      };

      limits.syncSize = lib.mkOption {
        type = lib.types.addCheck lib.types.int (x: x>=0);
        default = 0;
        description = ''
          Maximum number of blocks to sync at once.
          Set to `0` for adaptive.
        '';
      };

      extraNodes = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = ''
          List of additional peer IP addresses to add to the local list.
        '';
      };

      priorityNodes = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = ''
          List of peer IP addresses to connect to and
          attempt to keep the connection open.
        '';
      };

      exclusiveNodes = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = ''
          List of peer IP addresses to connect to *only*.
          If given the other peer options will be ignored.
        '';
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Extra lines to be added verbatim to monerod configuration.
        '';
      };

    };

  };


  ###### implementation

  config = lib.mkIf cfg.enable {

    users.users.monero = {
      isSystemUser = true;
      group = "monero";
      description = "Monero daemon user";
      home = cfg.dataDir;
      createHome = true;
    };

    users.groups.monero = { };

    systemd.services.monero = {
      description = "monero daemon";
      after    = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User  = "monero";
        Group = "monero";
        ExecStart = "${pkgs.monero-cli}/bin/monerod --config-file=${configFile} --non-interactive";
        Restart = "always";
        SuccessExitStatus = [ 0 1 ];
      };
    };

    assertions = lib.singleton {
      assertion = cfg.mining.enable -> cfg.mining.address != "";
      message   = ''
       You need a Monero address to receive mining rewards:
       specify one using option monero.mining.address.
      '';
    };

  };

  meta.maintainers = with lib.maintainers; [ rnhmjoj ];

}

