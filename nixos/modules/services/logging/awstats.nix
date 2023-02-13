{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.awstats;
  package = pkgs.awstats;
  configOpts = {name, config, ...}: {
    options = {
      type = mkOption{
        type = types.enum [ "mail" "web" ];
        default = "web";
        example = "mail";
        description = lib.mdDoc ''
          The type of log being collected.
        '';
      };
      domain = mkOption {
        type = types.str;
        default = name;
        description = lib.mdDoc "The domain name to collect stats for.";
        example = "example.com";
      };

      logFile = mkOption {
        type = types.str;
        example = "/var/log/nginx/access.log";
        description = lib.mdDoc ''
          The log file to be scanned.

          For mail, set this to
          ```
          journalctl $OLD_CURSOR -u postfix.service | ''${pkgs.perl}/bin/perl ''${pkgs.awstats.out}/share/awstats/tools/maillogconvert.pl standard |
          ```
        '';
      };

      logFormat = mkOption {
        type = types.str;
        default = "1";
        description = lib.mdDoc ''
          The log format being used.

          For mail, set this to
          ```
          %time2 %email %email_r %host %host_r %method %url %code %bytesd
          ```
        '';
      };

      hostAliases = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "www.example.org" ];
        description = lib.mdDoc ''
          List of aliases the site has.
        '';
      };

      extraConfig = mkOption {
        type = types.attrsOf types.str;
        default = {};
        example = literalExpression ''
          {
            "ValidHTTPCodes" = "404";
          }
        '';
        description = lib.mdDoc "Extra configuration to be appended to awstats.\${name}.conf.";
      };

      webService = {
        enable = mkEnableOption (lib.mdDoc "awstats web service");

        hostname = mkOption {
          type = types.str;
          default = config.domain;
          description = lib.mdDoc "The hostname the web service appears under.";
        };

        urlPrefix = mkOption {
          type = types.str;
          default = "/awstats";
          description = lib.mdDoc "The URL prefix under which the awstats pages appear.";
        };
      };
    };
  };
  webServices = filterAttrs (name: value: value.webService.enable) cfg.configs;
in
{
  imports = [
    (mkRemovedOptionModule [ "services" "awstats" "service" "enable" ] "Please enable per domain with `services.awstats.configs.<name>.webService.enable`")
    (mkRemovedOptionModule [ "services" "awstats" "service" "urlPrefix" ] "Please set per domain with `services.awstats.configs.<name>.webService.urlPrefix`")
    (mkRenamedOptionModule [ "services" "awstats" "vardir" ] [ "services" "awstats" "dataDir" ])
  ];

  options.services.awstats = {
    enable = mkEnableOption (lib.mdDoc "awstats");

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/awstats";
      description = lib.mdDoc "The directory where awstats data will be stored.";
    };

    configs = mkOption {
      type = types.attrsOf (types.submodule configOpts);
      default = {};
      example = literalExpression ''
        {
          "mysite" = {
            domain = "example.com";
            logFile = "/var/log/nginx/access.log";
          };
        }
      '';
      description = lib.mdDoc "Attribute set of domains to collect stats for.";
    };

    updateAt = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "hourly";
      description = lib.mdDoc ''
        Specification of the time at which awstats will get updated.
        (in the format described by {manpage}`systemd.time(7)`)
      '';
    };
  };


  config = mkIf cfg.enable {
    environment.systemPackages = [ package.bin ];

    environment.etc = mapAttrs' (name: opts:
    nameValuePair "awstats/awstats.${name}.conf" {
      source = pkgs.runCommand "awstats.${name}.conf"
      { preferLocalBuild = true; }
      (''
        sed \
      ''
      # set up mail stats
      + optionalString (opts.type == "mail")
      ''
        -e 's|^\(LogType\)=.*$|\1=M|' \
        -e 's|^\(LevelForBrowsersDetection\)=.*$|\1=0|' \
        -e 's|^\(LevelForOSDetection\)=.*$|\1=0|' \
        -e 's|^\(LevelForRefererAnalyze\)=.*$|\1=0|' \
        -e 's|^\(LevelForRobotsDetection\)=.*$|\1=0|' \
        -e 's|^\(LevelForSearchEnginesDetection\)=.*$|\1=0|' \
        -e 's|^\(LevelForFileTypesDetection\)=.*$|\1=0|' \
        -e 's|^\(LevelForWormsDetection\)=.*$|\1=0|' \
        -e 's|^\(ShowMenu\)=.*$|\1=1|' \
        -e 's|^\(ShowSummary\)=.*$|\1=HB|' \
        -e 's|^\(ShowMonthStats\)=.*$|\1=HB|' \
        -e 's|^\(ShowDaysOfMonthStats\)=.*$|\1=HB|' \
        -e 's|^\(ShowDaysOfWeekStats\)=.*$|\1=HB|' \
        -e 's|^\(ShowHoursStats\)=.*$|\1=HB|' \
        -e 's|^\(ShowDomainsStats\)=.*$|\1=0|' \
        -e 's|^\(ShowHostsStats\)=.*$|\1=HB|' \
        -e 's|^\(ShowAuthenticatedUsers\)=.*$|\1=0|' \
        -e 's|^\(ShowRobotsStats\)=.*$|\1=0|' \
        -e 's|^\(ShowEMailSenders\)=.*$|\1=HBML|' \
        -e 's|^\(ShowEMailReceivers\)=.*$|\1=HBML|' \
        -e 's|^\(ShowSessionsStats\)=.*$|\1=0|' \
        -e 's|^\(ShowPagesStats\)=.*$|\1=0|' \
        -e 's|^\(ShowFileTypesStats\)=.*$|\1=0|' \
        -e 's|^\(ShowFileSizesStats\)=.*$|\1=0|' \
        -e 's|^\(ShowBrowsersStats\)=.*$|\1=0|' \
        -e 's|^\(ShowOSStats\)=.*$|\1=0|' \
        -e 's|^\(ShowOriginStats\)=.*$|\1=0|' \
        -e 's|^\(ShowKeyphrasesStats\)=.*$|\1=0|' \
        -e 's|^\(ShowKeywordsStats\)=.*$|\1=0|' \
        -e 's|^\(ShowMiscStats\)=.*$|\1=0|' \
        -e 's|^\(ShowHTTPErrorsStats\)=.*$|\1=0|' \
        -e 's|^\(ShowSMTPErrorsStats\)=.*$|\1=1|' \
      ''
      +
      # common options
      ''
        -e 's|^\(DirData\)=.*$|\1="${cfg.dataDir}/${name}"|' \
        -e 's|^\(DirIcons\)=.*$|\1="icons"|' \
        -e 's|^\(CreateDirDataIfNotExists\)=.*$|\1=1|' \
        -e 's|^\(SiteDomain\)=.*$|\1="${name}"|' \
        -e 's|^\(LogFile\)=.*$|\1="${opts.logFile}"|' \
        -e 's|^\(LogFormat\)=.*$|\1="${opts.logFormat}"|' \
      ''
      +
      # extra config
      concatStringsSep "\n" (mapAttrsToList (n: v: ''
        -e 's|^\(${n}\)=.*$|\1="${v}"|' \
      '') opts.extraConfig)
      +
      ''
        < '${package.out}/wwwroot/cgi-bin/awstats.model.conf' > "$out"
      '');
    }) cfg.configs;

    # create data directory with the correct permissions
    systemd.tmpfiles.rules =
      [ "d '${cfg.dataDir}' 755 root root - -" ] ++
      mapAttrsToList (name: opts: "d '${cfg.dataDir}/${name}' 755 root root - -") cfg.configs ++
      [ "Z '${cfg.dataDir}' 755 root root - -" ];

    # nginx options
    services.nginx.virtualHosts = mapAttrs'(name: opts: {
      name = opts.webService.hostname;
      value = {
        locations = {
          "${opts.webService.urlPrefix}/css/" = {
            alias = "${package.out}/wwwroot/css/";
          };
          "${opts.webService.urlPrefix}/icons/" = {
            alias = "${package.out}/wwwroot/icon/";
          };
          "${opts.webService.urlPrefix}/" = {
            alias = "${cfg.dataDir}/${name}/";
            extraConfig = ''
              autoindex on;
            '';
          };
        };
      };
    }) webServices;

    # update awstats
    systemd.services = mkIf (cfg.updateAt != null) (mapAttrs' (name: opts:
      nameValuePair "awstats-${name}-update" {
        description = "update awstats for ${name}";
        script = optionalString (opts.type == "mail")
        ''
          if [[ -f "${cfg.dataDir}/${name}-cursor" ]]; then
            CURSOR="$(cat "${cfg.dataDir}/${name}-cursor" | tr -d '\n')"
            if [[ -n "$CURSOR" ]]; then
              echo "Using cursor: $CURSOR"
              export OLD_CURSOR="--cursor $CURSOR"
            fi
          fi
          NEW_CURSOR="$(journalctl $OLD_CURSOR -u postfix.service --show-cursor | tail -n 1 | tr -d '\n' | sed -e 's#^-- cursor: \(.*\)#\1#')"
          echo "New cursor: $NEW_CURSOR"
          ${package.bin}/bin/awstats -update -config=${name}
          if [ -n "$NEW_CURSOR" ]; then
            echo -n "$NEW_CURSOR" > ${cfg.dataDir}/${name}-cursor
          fi
        '' + ''
          ${package.out}/share/awstats/tools/awstats_buildstaticpages.pl \
            -config=${name} -update -dir=${cfg.dataDir}/${name} \
            -awstatsprog=${package.bin}/bin/awstats
        '';
        startAt = cfg.updateAt;
    }) cfg.configs);
  };

}

