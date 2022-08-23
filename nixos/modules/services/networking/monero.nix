{ config, lib, pkgs, ... }:

with lib;

let
  cfg     = config.services.monero;

  listToConf = option: list:
    concatMapStrings (value: "${option}=${value}\n") list;

  login = (cfg.rpc.user != null && cfg.rpc.password != null);

  configFile = with cfg; pkgs.writeText "monero.conf" ''
    log-file=/dev/stdout
    data-dir=${dataDir}

    ${optionalString mining.enable ''
      start-mining=${mining.address}
      mining-threads=${toString mining.threads}
    ''}

    rpc-bind-ip=${rpc.address}
    rpc-bind-port=${toString rpc.port}
    ${optionalString login ''
      rpc-login=${rpc.user}:${rpc.password}
    ''}
    ${optionalString rpc.restricted ''
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

      enable = mkEnableOption "Monero node daemon";

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/monero";
        description = lib.mdDoc ''
          The directory where Monero stores its data files.
        '';
      };

      mining.enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to mine monero.
        '';
      };

      mining.address = mkOption {
        type = types.str;
        default = "";
        description = lib.mdDoc ''
          Monero address where to send mining rewards.
        '';
      };

      mining.threads = mkOption {
        type = types.addCheck types.int (x: x>=0);
        default = 0;
        description = lib.mdDoc ''
          Number of threads used for mining.
          Set to `0` to use all available.
        '';
      };

      rpc.user = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc ''
          User name for RPC connections.
        '';
      };

      rpc.password = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc ''
          Password for RPC connections.
        '';
      };

      rpc.address = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = lib.mdDoc ''
          IP address the RPC server will bind to.
        '';
      };

      rpc.port = mkOption {
        type = types.port;
        default = 18081;
        description = lib.mdDoc ''
          Port the RPC server will bind to.
        '';
      };

      rpc.restricted = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to restrict RPC to view only commands.
        '';
      };

      limits.upload = mkOption {
        type = types.addCheck types.int (x: x>=-1);
        default = -1;
        description = lib.mdDoc ''
          Limit of the upload rate in kB/s.
          Set to `-1` to leave unlimited.
        '';
      };

      limits.download = mkOption {
        type = types.addCheck types.int (x: x>=-1);
        default = -1;
        description = lib.mdDoc ''
          Limit of the download rate in kB/s.
          Set to `-1` to leave unlimited.
        '';
      };

      limits.threads = mkOption {
        type = types.addCheck types.int (x: x>=0);
        default = 0;
        description = lib.mdDoc ''
          Maximum number of threads used for a parallel job.
          Set to `0` to leave unlimited.
        '';
      };

      limits.syncSize = mkOption {
        type = types.addCheck types.int (x: x>=0);
        default = 0;
        description = lib.mdDoc ''
          Maximum number of blocks to sync at once.
          Set to `0` for adaptive.
        '';
      };

      extraNodes = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = lib.mdDoc ''
          List of additional peer IP addresses to add to the local list.
        '';
      };

      priorityNodes = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = lib.mdDoc ''
          List of peer IP addresses to connect to and
          attempt to keep the connection open.
        '';
      };

      exclusiveNodes = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = lib.mdDoc ''
          List of peer IP addresses to connect to *only*.
          If given the other peer options will be ignored.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc ''
          Extra lines to be added verbatim to monerod configuration.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

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

    assertions = singleton {
      assertion = cfg.mining.enable -> cfg.mining.address != "";
      message   = ''
       You need a Monero address to receive mining rewards:
       specify one using option monero.mining.address.
      '';
    };

  };

  meta.maintainers = with lib.maintainers; [ rnhmjoj ];

}

