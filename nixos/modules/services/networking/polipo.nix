{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.polipo;

  polipoConfig = pkgs.writeText "polipo.conf" ''
    proxyAddress = ${cfg.proxyAddress}
    proxyPort = ${toString cfg.proxyPort}
    allowedClients = ${concatStringsSep ", " cfg.allowedClients}
    ${optionalString (cfg.parentProxy != "") "parentProxy = ${cfg.parentProxy}" }
    ${optionalString (cfg.socksParentProxy != "") "socksParentProxy = ${cfg.socksParentProxy}" }
    ${config.services.polipo.extraConfig}
  '';

in

{

  options = {

    services.polipo = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to run the polipo caching web proxy.";
      };

      proxyAddress = mkOption {
        type = types.string;
        default = "127.0.0.1";
        description = "IP address on which Polipo will listen.";
      };

      proxyPort = mkOption {
        type = types.int;
        default = 8123;
        description = "TCP port on which Polipo will listen.";
      };

      allowedClients = mkOption {
        type = types.listOf types.str;
        default = [ "127.0.0.1" "::1" ];
        example = [ "127.0.0.1" "::1" "134.157.168.0/24" "2001:660:116::/48" ];
        description = ''
          List of IP addresses or network addresses that may connect to Polipo.
        '';
      };

      parentProxy = mkOption {
        type = types.string;
        default = "";
        example = "localhost:8124";
        description = ''
          Hostname and port number of an HTTP parent proxy;
          it should have the form ‘host:port’.
        '';
      };

      socksParentProxy = mkOption {
        type = types.string;
        default = "";
        example = "localhost:9050";
        description = ''
          Hostname and port number of an SOCKS parent proxy;
          it should have the form ‘host:port’.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Polio configuration. Contents will be added 
          verbatim to the configuration file.
        '';
      };

    };

  };

  config = mkIf cfg.enable {

    users.extraUsers = singleton
      { name = "polipo";
        uid = config.ids.uids.polipo;
        description = "Polipo caching proxy user";
        home = "/var/cache/polipo";
        createHome = true;
      };

    users.extraGroups = singleton
      { name = "polipo";
        gid = config.ids.gids.polipo;
        members = [ "polipo" ];
      };

    systemd.services.polipo = {
      description = "caching web proxy";
      after = [ "network.target" "nss-lookup.target" ];
      wantedBy = [ "multi-user.target"];
      serviceConfig = {
        ExecStart  = "${pkgs.polipo}/bin/polipo -c ${polipoConfig}";
        User = "polipo";
      };
    };

  };

}