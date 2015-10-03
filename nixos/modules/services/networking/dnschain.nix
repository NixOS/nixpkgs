{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services;

  dnschainConf = pkgs.writeText "dnschain.conf" ''
    [log]
    level=info

    [dns]
    host = 127.0.0.1
    port = 5333
    oldDNSMethod = NO_OLD_DNS
    # TODO: check what that address is acutally used for
    externalIP = 127.0.0.1

    [http]
    host = 127.0.0.1
    port=8088
    tlsPort=4443
  '';

in

{

  ###### interface

  options = {

    services.dnschain = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to run dnschain. That implies running
          namecoind as well, so make sure to configure
          it appropriately.
        '';
      };

    };

    services.dnsmasq = {
      resolveDnschainQueries = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Resolve <literal>.bit</literal> top-level domains
          with dnschain and namecoind.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.dnschain.enable {

    services.namecoind.enable = true;

    services.dnsmasq.servers = optionals cfg.dnsmasq.resolveDnschainQueries [ "/.bit/127.0.0.1#5333" ];

    users.extraUsers = singleton
      { name = "dnschain";
        uid = config.ids.uids.dnschain;
        extraGroups = [ "namecoin" ];
        description = "Dnschain daemon user";
        home = "/var/lib/dnschain";
        createHome = true;
      };

    systemd.services.dnschain = {
        description = "Dnschain Daemon";
        after = [ "namecoind.target" ];
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.openssl ];
        preStart = ''
          # Link configuration file into dnschain HOME directory
          if [ "$(${pkgs.coreutils}/bin/realpath /var/lib/dnschain/.dnschain.conf)" != "${dnschainConf}" ]; then
              rm -rf /var/lib/dnschain/.dnschain.conf
              ln -s ${dnschainConf} /var/lib/dnschain/.dnschain.conf
          fi

          # Create empty namecoin.conf so that dnschain is not
          # searching for /etc/namecoin/namecoin.conf
          if [ ! -e /var/lib/dnschain/.namecoin/namecoin.conf ]; then
              mkdir -p /var/lib/dnschain/.namecoin
              touch /var/lib/dnschain/.namecoin/namecoin.conf
          fi
        '';
        serviceConfig = {
          Type = "simple";
          User = "dnschain";
          EnvironmentFile = config.services.namecoind.userFile;
          ExecStart = "${pkgs.dnschain}/bin/dnschain --rpcuser=\${USER} --rpcpassword=\${PASSWORD} --rpcport=8336";
          ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
          ExecStop = "${pkgs.coreutils}/bin/kill -KILL $MAINPID";
        };
    };

  };

}
