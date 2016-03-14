{ config, pkgs, lib, ... }:

let

  inherit (lib) mkOption mkIf singleton;
  inherit (pkgs) ddclient;

  stateDir = "/var/spool/ddclient";
  ddclientUser = "ddclient";
  ddclientFlags = "-foreground -verbose -noquiet -file ${ddclientCfg}";
  ddclientPIDFile = "${stateDir}/ddclient.pid";
  ddclientCfg = pkgs.writeText "ddclient.conf" ''
    daemon=600
    cache=${stateDir}/ddclient.cache
    pid=${ddclientPIDFile}
    use=${config.services.ddclient.use}
    login=${config.services.ddclient.username}
    password=${config.services.ddclient.password}
    protocol=${config.services.ddclient.protocol}
    server=${config.services.ddclient.server}
    ssl=${if config.services.ddclient.ssl then "yes" else "no"}
    wildcard=YES
    ${config.services.ddclient.domain}
    ${config.services.ddclient.extraConfig}
  '';

in

{

  ###### interface

  options = {

    services.ddclient = with lib.types; {

      enable = mkOption {
        default = false;
        type = bool;
        description = ''
          Whether to synchronise your machine's IP address with a dynamic DNS provider (e.g. dyndns.org).
        '';
      };

      domain = mkOption {
        default = "";
        type = str;
        description = ''
          Domain name to synchronize.
        '';
      };

      username = mkOption {
        default = "";
        type = str;
        description = ''
          Username.
        '';
      };

      password = mkOption {
        default = "";
        type = str;
        description = ''
          Password.
        '';
      };

      protocol = mkOption {
        default = "dyndns2";
        type = str;
        description = ''
          Protocol to use with dynamic DNS provider (see http://sourceforge.net/apps/trac/ddclient/wiki/Protocols).
        '';
      };

      server = mkOption {
        default = "";
        type = str;
        description = ''
          Server address.
        '';
      };

      ssl = mkOption {
        default = true;
        type = bool;
        description = ''
          Whether to use to use SSL/TLS to connect to dynamic DNS provider.
        '';
      };

      extraConfig = mkOption {
        default = "";
        type = str;
        description = ''
          Extra configuration. Contents will be added verbatim to the configuration file.
        '';
      };

      use = mkOption {
        default = "web, web=checkip.dyndns.com/, web-skip='Current IP Address: '";
        type = str;
        description = ''
          Method to determine the IP address to send to the dymanic DNS provider.
        '';
      };
    };
  };


  ###### implementation

  config = mkIf config.services.ddclient.enable {

    environment.systemPackages = [ ddclient ];

    users.extraUsers = singleton {
      name = ddclientUser;
      uid = config.ids.uids.ddclient;
      description = "ddclient daemon user";
      home = stateDir;
    };

    systemd.services.ddclient = {
      description = "Dynamic DNS Client";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        # Uncomment this if too many problems occur:
        # Type = "forking";
        User = ddclientUser;
        Group = "nogroup"; #TODO get this to work
        PermissionsStartOnly = "true";
        PIDFile = ddclientPIDFile;
        ExecStartPre = ''
          ${pkgs.stdenv.shell} -c "${pkgs.coreutils}/bin/mkdir -m 0755 -p ${stateDir} && ${pkgs.coreutils}/bin/chown ${ddclientUser} ${stateDir}"
        '';
        ExecStart = "${ddclient}/bin/ddclient ${ddclientFlags}";
        #ExecStartPost = "${pkgs.coreutils}/bin/rm -r ${stateDir}"; # Should we have this?
      };
    };
  };
}
