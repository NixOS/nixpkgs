{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.morty;

in

{

  ###### interface

  options = {

    services.morty = {

      enable = mkEnableOption
        "Morty proxy server. See https://github.com/asciimoo/morty";

      ipv6 = mkOption {
        type = types.bool;
        default = true;
        description = "Allow IPv6 HTTP requests?";
        defaultText = "Allow IPv6 HTTP requests.";
      };

      key = mkOption {
        type = types.str;
        default = "";
        description = ''
          HMAC url validation key (hexadecimal encoded).
          Leave blank to disable. Without validation key, anyone can
          submit proxy requests. Leave blank to disable.
        '';
        defaultText = "No HMAC url validation. Generate with echo -n somevalue | openssl dgst -sha1 -hmac somekey";
      };

      timeout = mkOption {
        type = types.int;
        default = 2;
        description = "Request timeout in seconds.";
        defaultText = "A resource now gets 2 seconds to respond.";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.morty;
        defaultText = "pkgs.morty";
        description = "morty package to use.";
      };

      port = mkOption {
        type = types.int;
        default = 3000;
        description = "Listing port";
      };

      listenAddress = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "The address on which the service listens";
        defaultText = "127.0.0.1 (localhost)";
      };

    };

  };

  ###### Service definition

  config = mkIf config.services.morty.enable {

    users.users.morty =
      { description = "Morty user";
        createHome = true;
        home = "/var/lib/morty";
        isSystemUser = true;
        group = "morty";
      };
    users.groups.morty = {};

    systemd.services.morty =
      {
        description = "Morty sanitizing proxy server.";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = "morty";
          ExecStart = ''${cfg.package}/bin/morty              \
            -listen ${cfg.listenAddress}:${toString cfg.port} \
            ${optionalString cfg.ipv6 "-ipv6"}                \
            ${optionalString (cfg.key != "") "-key " + cfg.key} \
          '';
        };
      };
    environment.systemPackages = [ cfg.package ];

  };
}
