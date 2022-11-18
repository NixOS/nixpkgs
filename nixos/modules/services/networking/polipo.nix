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

      enable = mkEnableOption (lib.mdDoc "polipo caching web proxy");

      proxyAddress = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = lib.mdDoc "IP address on which Polipo will listen.";
      };

      proxyPort = mkOption {
        type = types.port;
        default = 8123;
        description = lib.mdDoc "TCP port on which Polipo will listen.";
      };

      allowedClients = mkOption {
        type = types.listOf types.str;
        default = [ "127.0.0.1" "::1" ];
        example = [ "127.0.0.1" "::1" "134.157.168.0/24" "2001:660:116::/48" ];
        description = lib.mdDoc ''
          List of IP addresses or network addresses that may connect to Polipo.
        '';
      };

      parentProxy = mkOption {
        type = types.str;
        default = "";
        example = "localhost:8124";
        description = lib.mdDoc ''
          Hostname and port number of an HTTP parent proxy;
          it should have the form ‘host:port’.
        '';
      };

      socksParentProxy = mkOption {
        type = types.str;
        default = "";
        example = "localhost:9050";
        description = lib.mdDoc ''
          Hostname and port number of an SOCKS parent proxy;
          it should have the form ‘host:port’.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc ''
          Polio configuration. Contents will be added
          verbatim to the configuration file.
        '';
      };

    };

  };

  config = mkIf cfg.enable {

    users.users.polipo =
      { uid = config.ids.uids.polipo;
        description = "Polipo caching proxy user";
        home = "/var/cache/polipo";
        createHome = true;
      };

    users.groups.polipo =
      { gid = config.ids.gids.polipo;
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
