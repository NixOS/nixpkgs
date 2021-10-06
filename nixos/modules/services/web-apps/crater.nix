{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.crater;
  fpm = config.services.phpfpm.pools.crater;
  package = pkgs.crater.override { dataDir = cfg.dataDir; };
  webserver = config.services.caddy;

in
{
  options.services.crater = {

    enable = mkOption {
      default = false;
      type = types.bool;
      description = lib.mdDoc ''
        Enable Crater. For the initial start you'll have to complete the setup
        using the installation assistent in the web interface.
      '';
    };

    hostName = mkOption {
      default = "localhost";
      description = lib.mdDoc "FQDN for the Crater instance.";
      type = types.str;
    };

    dataDir = mkOption {
      default = "/var/lib/crater";
      description = lib.mdDoc "Directory to store Crater state/data files.";
      type = types.str;
    };

    poolConfig = mkOption {
      type = with types; attrsOf (oneOf [ str int bool ]);
      default = {
        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 4;
        "pm.max_requests" = 500;
      };
      description = lib.mdDoc ''
        Options for the crater PHP pool. See the documentation on <literal>php-fpm.conf</literal>
        for details on configuration directives.
      '';
    };

  };

  config = mkIf cfg.enable {

    services.phpfpm.pools.crater = {

      # copy/paste from ${crater}/docker-compose/php/uploads.ini
      phpOptions = ''
        file_uploads = On
        upload_max_filesize = 64M
        post_max_size = 64M
      '';

      user = webserver.user;
      group = webserver.group;

      settings = {
        "listen.mode" = "0660";
        "listen.owner" = webserver.user;
        "listen.group" = webserver.group;
      } // cfg.poolConfig;
    };

    services.caddy = {
      enable = true;
      virtualHosts."http://${cfg.hostName}" = {
        extraConfig = ''
          root    * /${package}/public
          file_server
          php_fastcgi unix/${fpm.socket}
        '';
      };
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir}                            0711 ${webserver.user} ${webserver.group} - -"
      "f ${cfg.dataDir}/database.sqlite            0700 ${webserver.user} ${webserver.group} - -"
      "d ${cfg.dataDir}/public                     0755 ${webserver.user} ${webserver.group} - -"
      "d ${cfg.dataDir}/storage                    0711 ${webserver.user} ${webserver.group} - -"
      "d ${cfg.dataDir}/storage/app                0711 ${webserver.user} ${webserver.group} - -"
      "d ${cfg.dataDir}/storage/fonts              0700 ${webserver.user} ${webserver.group} - -"
      "d ${cfg.dataDir}/storage/framework          0775 ${webserver.user} ${webserver.group} - -"
      "d ${cfg.dataDir}/storage/framework/cache    0700 ${webserver.user} ${webserver.group} - -"
      "d ${cfg.dataDir}/storage/framework/sessions 0700 ${webserver.user} ${webserver.group} - -"
      "d ${cfg.dataDir}/storage/framework/views    0700 ${webserver.user} ${webserver.group} - -"
      "d ${cfg.dataDir}/storage/logs               0775 ${webserver.user} ${webserver.group} - -"
      "C ${cfg.dataDir}/.env                       0700 ${webserver.user} ${webserver.group} - ${package}/.env.example"
      "d ${cfg.dataDir}/bootstrap                  0711 ${webserver.user} ${webserver.group} - -"
      "d ${cfg.dataDir}/bootstrap/cache            0775 ${webserver.user} ${webserver.group} - -"
    ];

  };
}
