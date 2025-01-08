{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.polipo;

  polipoConfig = pkgs.writeText "polipo.conf" ''
    proxyAddress = ${cfg.proxyAddress}
    proxyPort = ${toString cfg.proxyPort}
    allowedClients = ${lib.concatStringsSep ", " cfg.allowedClients}
    ${lib.optionalString (cfg.parentProxy != "") "parentProxy = ${cfg.parentProxy}"}
    ${lib.optionalString (cfg.socksParentProxy != "") "socksParentProxy = ${cfg.socksParentProxy}"}
    ${config.services.polipo.extraConfig}
  '';

in

{

  options = {

    services.polipo = {

      enable = lib.mkEnableOption "polipo caching web proxy";

      proxyAddress = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "IP address on which Polipo will listen.";
      };

      proxyPort = lib.mkOption {
        type = lib.types.port;
        default = 8123;
        description = "TCP port on which Polipo will listen.";
      };

      allowedClients = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "127.0.0.1"
          "::1"
        ];
        example = [
          "127.0.0.1"
          "::1"
          "134.157.168.0/24"
          "2001:660:116::/48"
        ];
        description = ''
          List of IP addresses or network addresses that may connect to Polipo.
        '';
      };

      parentProxy = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "localhost:8124";
        description = ''
          Hostname and port number of an HTTP parent proxy;
          it should have the form ‘host:port’.
        '';
      };

      socksParentProxy = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "localhost:9050";
        description = ''
          Hostname and port number of an SOCKS parent proxy;
          it should have the form ‘host:port’.
        '';
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Polio configuration. Contents will be added
          verbatim to the configuration file.
        '';
      };

    };

  };

  config = lib.mkIf cfg.enable {

    users.users.polipo = {
      uid = config.ids.uids.polipo;
      description = "Polipo caching proxy user";
      home = "/var/cache/polipo";
      createHome = true;
    };

    users.groups.polipo = {
      gid = config.ids.gids.polipo;
      members = [ "polipo" ];
    };

    systemd.services.polipo = {
      description = "caching web proxy";
      after = [
        "network.target"
        "nss-lookup.target"
      ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.polipo}/bin/polipo -c ${polipoConfig}";
        User = "polipo";
      };
    };

  };

}
