
{ config, lib, pkgs, ... }:

with lib;

let
  cfg     = config.services.namecoind;
  dataDir = "/var/lib/namecoind";
  useSSL  = (cfg.rpc.certificate != null) && (cfg.rpc.key != null);
  useRPC  = (cfg.rpc.user != null) && (cfg.rpc.password != null);

  listToConf = option: list:
    concatMapStrings (value :"${option}=${value}\n") list;

  configFile = pkgs.writeText "namecoin.conf" (''
    server=1
    daemon=0
    txindex=1
    txprevcache=1
    walletpath=${cfg.wallet}
    gen=${if cfg.generate then "1" else "0"}
    ${listToConf "addnode" cfg.extraNodes}
    ${listToConf "connect" cfg.trustedNodes}
  '' + optionalString useRPC ''
    rpcbind=${cfg.rpc.address}
    rpcport=${toString cfg.rpc.port}
    rpcuser=${cfg.rpc.user}
    rpcpassword=${cfg.rpc.password}
    ${listToConf "rpcallowip" cfg.rpc.allowFrom}
  '' + optionalString useSSL ''
    rpcssl=1
    rpcsslcertificatechainfile=${cfg.rpc.certificate}
    rpcsslprivatekeyfile=${cfg.rpc.key}
    rpcsslciphers=TLSv1.2+HIGH:TLSv1+HIGH:!SSLv2:!aNULL:!eNULL:!3DES:@STRENGTH
  '');

in

{

  ###### interface

  options = {

    services.namecoind = {

      enable = mkEnableOption "namecoind, Namecoin client";

      wallet = mkOption {
        type = types.path;
        default = "${dataDir}/wallet.dat";
        description = lib.mdDoc ''
          Wallet file. The ownership of the file has to be
          namecoin:namecoin, and the permissions must be 0640.
        '';
      };

      generate = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to generate (mine) Namecoins.
        '';
      };

      extraNodes = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = lib.mdDoc ''
          List of additional peer IP addresses to connect to.
        '';
      };

      trustedNodes = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = lib.mdDoc ''
          List of the only peer IP addresses to connect to. If specified
          no other connection will be made.
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
        default = "0.0.0.0";
        description = lib.mdDoc ''
          IP address the RPC server will bind to.
        '';
      };

      rpc.port = mkOption {
        type = types.port;
        default = 8332;
        description = lib.mdDoc ''
          Port the RPC server will bind to.
        '';
      };

      rpc.certificate = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/var/lib/namecoind/server.cert";
        description = lib.mdDoc ''
          Certificate file for securing RPC connections.
        '';
      };

      rpc.key = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/var/lib/namecoind/server.pem";
        description = lib.mdDoc ''
          Key file for securing RPC connections.
        '';
      };


      rpc.allowFrom = mkOption {
        type = types.listOf types.str;
        default = [ "127.0.0.1" ];
        description = lib.mdDoc ''
          List of IP address ranges allowed to use the RPC API.
          Wiledcards (*) can be user to specify a range.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    users.users.namecoin = {
      uid  = config.ids.uids.namecoin;
      description = "Namecoin daemon user";
      home = dataDir;
      createHome = true;
    };

    users.groups.namecoin = {
      gid  = config.ids.gids.namecoin;
    };

    systemd.services.namecoind = {
      description = "Namecoind daemon";
      after    = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      startLimitIntervalSec = 120;
      startLimitBurst = 5;
      serviceConfig = {
        User  = "namecoin";
        Group = "namecoin";
        ExecStart  = "${pkgs.namecoind}/bin/namecoind -conf=${configFile} -datadir=${dataDir} -printtoconsole";
        ExecStop   = "${pkgs.coreutils}/bin/kill -KILL $MAINPID";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        Nice = "10";
        PrivateTmp = true;
        TimeoutStopSec     = "60s";
        TimeoutStartSec    = "2s";
        Restart            = "always";
      };

      preStart = optionalString (cfg.wallet != "${dataDir}/wallet.dat")  ''
        # check wallet file permissions
        if [ "$(stat --printf '%u' ${cfg.wallet})" != "${toString config.ids.uids.namecoin}" \
           -o "$(stat --printf '%g' ${cfg.wallet})" != "${toString config.ids.gids.namecoin}" \
           -o "$(stat --printf '%a' ${cfg.wallet})" != "640" ]; then
           echo "ERROR: bad ownership or rights on ${cfg.wallet}" >&2
           exit 1
        fi
      '';

    };

  };

  meta.maintainers = with lib.maintainers; [ rnhmjoj ];

}
