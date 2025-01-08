{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.morty;

in

{

  ###### interface

  options = {

    services.morty = {

      enable = lib.mkEnableOption "Morty proxy server. See https://github.com/asciimoo/morty";

      ipv6 = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Allow IPv6 HTTP requests?";
      };

      key = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          HMAC url validation key (hexadecimal encoded).
          Leave blank to disable. Without validation key, anyone can
          submit proxy requests. Leave blank to disable.
          Generate with `printf %s somevalue | openssl dgst -sha1 -hmac somekey`
        '';
      };

      timeout = lib.mkOption {
        type = lib.types.int;
        default = 2;
        description = "Request timeout in seconds.";
      };

      package = lib.mkPackageOption pkgs "morty" { };

      port = lib.mkOption {
        type = lib.types.port;
        default = 3000;
        description = "Listing port";
      };

      listenAddress = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "The address on which the service listens";
      };

    };

  };

  ###### Service definition

  config = lib.mkIf config.services.morty.enable {

    users.users.morty = {
      description = "Morty user";
      createHome = true;
      home = "/var/lib/morty";
      isSystemUser = true;
      group = "morty";
    };
    users.groups.morty = { };

    systemd.services.morty = {
      description = "Morty sanitizing proxy server.";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "morty";
        ExecStart = ''
          ${cfg.package}/bin/morty              \
                      -listen ${cfg.listenAddress}:${toString cfg.port} \
                      ${lib.optionalString cfg.ipv6 "-ipv6"}                \
                      ${lib.optionalString (cfg.key != "") "-key " + cfg.key} \
        '';
      };
    };
    environment.systemPackages = [ cfg.package ];

  };
}
