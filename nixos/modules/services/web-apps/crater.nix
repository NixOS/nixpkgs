{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault mkEnableOption mkIf mkOption types;

  cfg = config.services.crater;
  fpm = config.services.phpfpm.pools.crater;
  package = pkgs.crater.override { dataDir = cfg.dataDir; };
in
{
  options.services.crater = {

    enable = mkEnableOption "Crater";

    user = mkOption {
      default = "crater";
      description = "User crater runs as.";
      type = types.str;
    };

    group = mkOption {
      default = "crater";
      description = "Group crater runs as.";
      type = types.str;
    };

    dataDir = mkOption {
      default = "/var/lib/crater";
      description = "Directory to store Crater state/data files.";
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
      description = ''
        Options for the crater PHP pool. See the documentation on <literal>php-fpm.conf</literal>
        for details on configuration directives.
      '';
    };

  };

  config = mkIf cfg.enable {

    services.phpfpm.pools.crater = {
      inherit (cfg) user group;

      # copy/paste from ${crater}/docker-compose/php/uploads.ini
      phpOptions = ''
        file_uploads = On
        upload_max_filesize = 64M
        post_max_size = 64M
      '';

      settings = {
        "listen.mode" = "0660";
        "listen.owner" = cfg.user;
        "listen.group" = cfg.group;
      } // cfg.poolConfig;
    };

    services.httpd = {
      enable = true;
      extraModules = [ "proxy_fcgi" ];
      virtualHosts.crater = {
        documentRoot = "${package}/public";

        extraConfig = ''
          <Directory ${package}/public>
            <FilesMatch "\.php$">
              <If "-f %{REQUEST_FILENAME}">
                SetHandler "proxy:unix:${fpm.socket}|fcgi://localhost/"
              </If>
            </FilesMatch>

            AllowOverride all
            Require all granted
            Options -Indexes
            DirectoryIndex index.php
          </Directory>
        '';
      };
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir}                            0711 ${cfg.user} ${cfg.group} - -"
      "f ${cfg.dataDir}/database.sqlite            0700 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.dataDir}/public                     0755 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.dataDir}/storage                    0711 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.dataDir}/storage/app                0711 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.dataDir}/storage/fonts              0700 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.dataDir}/storage/framework          0700 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.dataDir}/storage/framework/cache    0700 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.dataDir}/storage/framework/sessions 0700 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.dataDir}/storage/framework/views    0700 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.dataDir}/storage/logs               0700 ${cfg.user} ${cfg.group} - -"
      "C ${cfg.dataDir}/.env                       0700 ${cfg.user} ${cfg.group} - ${package}/.env.example"
    ];

    users.users.crater = mkIf (cfg.user == "crater") {
      isSystemUser = true;
      group = cfg.group;
    };

    users.groups.crater = mkIf (cfg.group == "crater") {};

    # grant the web server user access required to present this site
    users.users.wwwrun.extraGroups = [ cfg.user ];

  };
}
