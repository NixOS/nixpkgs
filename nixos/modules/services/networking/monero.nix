{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.monero;

  listToConf = option: list: lib.concatMapStrings (value: "${option}=${value}\n") list;

  login = (cfg.rpc.user != null && cfg.rpc.password != null);

  configFile =
    with cfg;
    pkgs.writeText "monero.conf" ''
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

      ${lib.optionalString (banlist != null) ''
        ban-list=${banlist}
      ''}

      limit-rate-up=${toString limits.upload}
      limit-rate-down=${toString limits.download}
      max-concurrency=${toString limits.threads}
      block-sync-size=${toString limits.syncSize}

      ${listToConf "add-peer" extraNodes}
      ${listToConf "add-priority-node" priorityNodes}
      ${listToConf "add-exclusive-node" exclusiveNodes}

      ${lib.optionalString prune ''
        prune-blockchain=1
        sync-pruned-blocks=1
      ''}

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

      banlist = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Path to a text file containing IPs to block.
          Useful to prevent DDoS/deanonymization attacks.

          <https://github.com/monero-project/meta/issues/1124>
        '';
        example = lib.literalExpression ''
          builtins.fetchurl {
            url = "https://raw.githubusercontent.com/rblaine95/monero-banlist/c6eb9413ddc777e7072d822f49923df0b2a94d88/block.txt";
            hash = "";
          };
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
        type = lib.types.ints.unsigned;
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
        type = lib.types.addCheck lib.types.int (x: x >= -1);
        default = -1;
        description = ''
          Limit of the upload rate in kB/s.
          Set to `-1` to leave unlimited.
        '';
      };

      limits.download = lib.mkOption {
        type = lib.types.addCheck lib.types.int (x: x >= -1);
        default = -1;
        description = ''
          Limit of the download rate in kB/s.
          Set to `-1` to leave unlimited.
        '';
      };

      limits.threads = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 0;
        description = ''
          Maximum number of threads used for a parallel job.
          Set to `0` to leave unlimited.
        '';
      };

      limits.syncSize = lib.mkOption {
        type = lib.types.ints.unsigned;
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

      prune = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to prune the blockchain.
          <https://www.getmonero.org/resources/moneropedia/pruning.html>
        '';
      };

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/var/lib/monero/monerod.env";
        description = ''
          Path to an EnvironmentFile for the monero service as defined in {manpage}`systemd.exec(5)`.

          Secrets may be passed to the service by specifying placeholder variables in the Nix config
          and setting values in the environment file.

          Example:

          ```
          # In environment file:
          MINING_ADDRESS=888tNkZrPN6JsEgekjMnABU4TBzc2Dt29EPAvkRxbANsAnjyPbb3iQ1YBRk1UXcdRsiKc9dhwMVgN5S9cQUiyoogDavup3H
          ```

          ```
          # Service config
          services.monero.mining.address = "$MINING_ADDRESS";
          ```
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
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        umask 077
        ${pkgs.envsubst}/bin/envsubst \
          -i ${configFile} \
          -o ${cfg.dataDir}/monerod.conf
      '';

      serviceConfig = {
        User = "monero";
        Group = "monero";
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];
        ExecStart = "${lib.getExe' pkgs.monero-cli "monerod"} --config-file=${cfg.dataDir}/monerod.conf --non-interactive";
        Restart = "always";
        SuccessExitStatus = [
          0
          1
        ];
      };
    };

    assertions = lib.singleton {
      assertion = cfg.mining.enable -> cfg.mining.address != "";
      message = ''
        You need a Monero address to receive mining rewards:
        specify one using option monero.mining.address.
      '';
    };

  };

  meta.maintainers = with lib.maintainers; [ rnhmjoj ];

}
