{config, pkgs, ...}:

with pkgs.lib;
let
  cfg = config.services.venus;

  configFile = pkgs.writeText "venus.ini"
    ''
      [Planet]
      name = ${cfg.name}
      link = ${cfg.link}
      owner_name = ${cfg.ownerName}
      owner_email = ${cfg.ownerEmail}
      output_theme = ${cfg.cacheDirectory}/theme
      output_dir = ${cfg.outputDirectory}
      cache_directory = ${cfg.cacheDirectory}
      items_per_page = ${toString cfg.itemsPerPage}
      ${(concatStringsSep "\n\n"
            (map ({ name, feedUrl, homepageUrl }:
            ''
              [${feedUrl}]
              name = ${name}
              link = ${homepageUrl}
            '') cfg.feeds))}
    '';

  cronJob = ''
    ${cfg.cronInterval} ${cfg.cronUser} ${pkgs.venus}/bin/venus-planet ${configFile}
  '';

in
{

  options = {
    services.venus = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Planet Venus is an awesome ‘river of news’ feed reader. It downloads
          news feeds published by web sites and aggregates their content
          together into a single combined feed, latest news first.
        '';
      };

      cronInterval = mkOption {
        default = "*/10 * * * *";
        type = types.string;
        description = ''
          Interval in cron format. Default is every 10 minutes.
        '';
      };

      cronUser = mkOption {
        default = "root";
        type = types.string;
        description = ''
          User for running the cron job.
        '';
      };

      name = mkOption {
        default = "NixOS Planet";
        type = types.string;
        description = ''
          Your planet's name.
        '';
      };

      link = mkOption {
        default = "http://planet.nixos.org";
        type = types.string;
        description = ''
          Link to the main page.
        '';
      };

      ownerName = mkOption {
        default = "Rok Garbas";
        type = types.string;
        description = ''
          Your name.
        '';
      };

      ownerEmail = mkOption {
        default = "some@example.com";
        type = types.string;
        description = ''
          Your e-mail address.
        '';
      };

      outputTheme = mkOption {
        default = "${pkgs.venus}/themes/classic_fancy";
        type = types.path;
        description = ''
          Directory containing a config.ini file which is merged with this one.
          This is typically used to specify templating and bill of material
          information.
        '';
      };

      outputDirectory = mkOption {
        type = types.path;
        description = ''
          Directory to place output files.
        '';
      };

      cacheDirectory = mkOption {
        default = "/var/cache/venus";
        type = types.path;
        description = ''
            Where cached feeds are stored.
        '';
      };

      itemsPerPage = mkOption {
        default = 15;
        type = types.int;
        description = ''
          How many items to put on each page.
        '';
      };

      feeds = mkOption {
        default = [];
        example = [
          {
            name = "Rok Garbas";
            feedUrl= "http://url/to/rss/feed.xml";
            homepageUrl = "http://garbas.si";
          }
        ];
        description = ''
          List of feeds.
        '';
      };

    };
  };

  config = mkIf cfg.enable {
    system.activationScripts.venus =
      ''
        mkdir -p ${cfg.outputDirectory}
        chown ${cfg.cronUser} ${cfg.outputDirectory} -R
        rm -rf ${cfg.cacheDirectory}/themes
        mkdir -p ${cfg.cacheDirectory}/themes
        cp -R ${cfg.outputTheme}/* ${cfg.cacheDirectory}/theme
        chown ${cfg.cronUser} ${cfg.cacheDirectory} -R
      '';
    services.cron.systemCronJobs = [ cronJob ];

  };
}
