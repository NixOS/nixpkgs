{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.lighttpd.nextcloud;
  phpfpmSocketName = "/run/phpfpm/nextcloud.sock";
in
{
  options.services.lighttpd.nextcloud = {

    enable = mkEnableOption "Nextcloud in lighttpd";

    package = mkOption {
      type = types.package;
      default = pkgs.nextcloud;
      defaultText = "pkgs.nextcloud";
      description = "Nextcloud package to use.";
    };

    installPrefix = mkOption {
      type = types.path;
      default = "/var/lib/nextcloud";
      description = ''
        Where to install Nextcloud. By default, user files will be placed in
        the data/ directory below the <option>installPrefix</option> directory.
      '';
    };

    urlPrefix = mkOption {
      type = types.str;
      default = "/nextcloud";
      example = "/";
      description = ''
        The prefix below the web server root URL to serve Nextcloud.
      '';
    };

    vhostsPattern = mkOption {
      type = types.str;
      default = ".*";
      example = "(myserver1.example|myserver2.example)";
      description = ''
        A virtual host regexp filter. Change it if you want Nextcloud to only
        be served from some host names, instead of all.
      '';
    };

  };

  config = mkIf (config.services.lighttpd.enable && cfg.enable) {

    systemd.services.lighttpd.preStart =
      ''
        echo "Setting up Nextcloud in ${cfg.installPrefix}/"
        ${pkgs.rsync}/bin/rsync -a --checksum "${cfg.package}/" "${cfg.installPrefix}/"

        mkdir -p "${cfg.installPrefix}/data"
        chown -R lighttpd:lighttpd "${cfg.installPrefix}"
        chmod 775 "${cfg.installPrefix}"
        chmod 770 "${cfg.installPrefix}/data"
        chmod 770 "${cfg.installPrefix}/apps"
        chmod 770 "${cfg.installPrefix}/config"
        chmod 660 "${cfg.installPrefix}/.user.ini"
        chmod 660 "${cfg.installPrefix}/.htaccess"
      '';

    services.lighttpd = {
      enableModules = [ "mod_alias" "mod_fastcgi" "mod_access" "mod_setenv" ];
      extraConfig = ''
        mimetype.assign += (
            ".svg" => "image/svg+xml",
        )

        $HTTP["host"] =~ "${cfg.vhostsPattern}" {
            alias.url += ( "${cfg.urlPrefix}" => "${cfg.installPrefix}/" )
            # Prevent direct access to the data directory, like nextcloud warns
            # about in its admin interface "Security & setup warnings".
            $HTTP["url"] =~ "^${cfg.urlPrefix}/data" {
                url.access-deny = ("")
            }
            $HTTP["url"] =~ "^${cfg.urlPrefix}" {
                fastcgi.server = (
                    ".php" => (
                        "phpfpm-nextcloud" => (
                            "socket" => "${phpfpmSocketName}",
                        )
                    )
                )
            }
            # Recommended setting (Nextcloud warns about this in the admin interface)
            $HTTP["scheme"] == "https" {
                setenv.add-response-header += (
                    "Strict-Transport-Security" => "max-age=15552000; includeSubDomains; preload"
                )
            }
        }
      '';
    };

    services.phpfpm.poolConfigs = {
      nextcloud = ''
        listen = ${phpfpmSocketName}
        listen.group = lighttpd
        user = lighttpd
        group = lighttpd
        pm = dynamic
        pm.max_children = 75
        pm.start_servers = 10
        pm.min_spare_servers = 5
        pm.max_spare_servers = 20
        pm.max_requests = 500
      '';
    };

  };

}
