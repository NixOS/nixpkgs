{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.namecoind;

  namecoinConf =
  let
    useSSL = (cfg.rpcCertificate != null) && (cfg.rpcKey != null);
  in
  pkgs.writeText "namecoin.conf" ''
    server=1
    daemon=0
    rpcallowip=127.0.0.1
    walletpath=${cfg.wallet}
    gen=${if cfg.generate then "1" else "0"}
    rpcssl=${if useSSL then "1" else "0"}
    ${optionalString useSSL "rpcsslcertificatechainfile=${cfg.rpcCertificate}"}
    ${optionalString useSSL "rpcsslprivatekeyfile=${cfg.rpcKey}"}
    ${optionalString useSSL "rpcsslciphers=TLSv1.2+HIGH:TLSv1+HIGH:!SSLv2:!aNULL:!eNULL:!3DES:@STRENGTH"}
    txindex=1
    txprevcache=1
  '';

in

{

  ###### interface

  options = {

    services.namecoind = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to run namecoind.
        '';
      };

      wallet = mkOption {
        type = types.path;
        example = "/etc/namecoin/wallet.dat";
        description = ''
          Wallet file. The ownership of the file has to be
          namecoin:namecoin, and the permissions must be 0640.
        '';
      };

      userFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/etc/namecoin/user";
        description = ''
          File containing the user name and user password to
          authenticate RPC connections to namecoind.
          The content of the file is of the form:
          <literal>
          USER=namecoin
          PASSWORD=secret
          </literal>
          The ownership of the file has to be namecoin:namecoin,
          and the permissions must be 0640.
        '';
      };

      generate = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to generate (mine) Namecoins.
        '';
      };

      rpcCertificate = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/etc/namecoin/server.cert";
        description = ''
          Certificate file for securing RPC connections.
        '';
      };

      rpcKey = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/etc/namecoin/server.pem";
        description = ''
          Key file for securing RPC connections.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    users.extraUsers = singleton
      { name = "namecoin";
        uid = config.ids.uids.namecoin;
        description = "Namecoin daemon user";
        home = "/var/lib/namecoin";
        createHome = true;
      };

    users.extraGroups = singleton
      { name = "namecoin";
        gid = config.ids.gids.namecoin;
      };

    systemd.services.namecoind = {
        description = "Namecoind Daemon";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        preStart = ''
          if [  "$(stat --printf '%u' ${cfg.userFile})" != "${toString config.ids.uids.namecoin}" \
             -o "$(stat --printf '%g' ${cfg.userFile})" != "${toString config.ids.gids.namecoin}" \
             -o "$(stat --printf '%a' ${cfg.userFile})" != "640" ]; then
             echo "ERROR: bad ownership or rights on ${cfg.userFile}" >&2
             exit 1
          fi
          if [  "$(stat --printf '%u' ${cfg.wallet})" != "${toString config.ids.uids.namecoin}" \
             -o "$(stat --printf '%g' ${cfg.wallet})" != "${toString config.ids.gids.namecoin}" \
             -o "$(stat --printf '%a' ${cfg.wallet})" != "640" ]; then
             echo "ERROR: bad ownership or rights on ${cfg.wallet}" >&2
             exit 1
          fi
        '';
        serviceConfig = {
          Type = "simple";
          User = "namecoin";
          EnvironmentFile = cfg.userFile;
          ExecStart = "${pkgs.altcoins.namecoind}/bin/namecoind -conf=${namecoinConf} -rpcuser=\${USER} -rpcpassword=\${PASSWORD} -printtoconsole";
          ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
          ExecStop = "${pkgs.coreutils}/bin/kill -KILL $MAINPID";
          StandardOutput = "null";
          Nice = "10";
        };
    };

  };

}
