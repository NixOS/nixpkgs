{ config, lib, pkgs, ... }:

with lib;
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

      dates = mkOption {
        default = "*:0/15";
        type = types.str;
        description = ''
          Specification (in the format described by
          <citerefentry><refentrytitle>systemd.time</refentrytitle>
          <manvolnum>5</manvolnum></citerefentry>) of the time at
          which the Venus will collect feeds.
        '';
      };

      user = mkOption {
        default = "root";
        type = types.str;
        description = ''
          User for running venus script.
        '';
      };

      group = mkOption {
        default = "root";
        type = types.str;
        description = ''
          Group for running venus script.
        '';
      };

      name = mkOption {
        default = "NixOS Planet";
        type = types.str;
        description = ''
          Your planet's name.
        '';
      };

      link = mkOption {
        default = "http://planet.nixos.org";
        type = types.str;
        description = ''
          Link to the main page.
        '';
      };

      ownerName = mkOption {
        default = "Rok Garbas";
        type = types.str;
        description = ''
          Your name.
        '';
      };

      ownerEmail = mkOption {
        default = "some@example.com";
        type = types.str;
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
        chown ${cfg.user}:${cfg.group} ${cfg.outputDirectory} -R
        rm -rf ${cfg.cacheDirectory}/theme
        mkdir -p ${cfg.cacheDirectory}/theme
        cp -R ${cfg.outputTheme}/* ${cfg.cacheDirectory}/theme
        chown ${cfg.user}:${cfg.group} ${cfg.cacheDirectory} -R
      '';

    systemd.services.venus =
      { description = "Planet Venus Feed Reader";
        path  = [ pkgs.venus ];
        script = "exec venus-planet ${configFile}";
        serviceConfig.User = "${cfg.user}";
        serviceConfig.Group = "${cfg.group}";
        startAt = cfg.dates;
      };

  };
}
