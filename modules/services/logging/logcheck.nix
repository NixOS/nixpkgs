{config, pkgs, ...}:

with pkgs.lib;

let
  cfg = config.services.logcheck;

  rulesDir = pkgs.runCommand "logcheck-rules-dir"
    {} (
    ''
      mkdir $out
      cp -prd ${pkgs.logcheck}/etc/logcheck/* $out/
      rm $out/logcheck.*
    '' + optionalString (! builtins.isNull cfg.extraRulesDir) ''
      cp -prd ${cfg.extraRulesDir}/* $out/
    '' );

  configFile = pkgs.writeText "logcheck.conf" cfg.config;

  logFiles = pkgs.writeText "logcheck.logfiles" cfg.files;

  flags = "-r ${rulesDir} -c ${configFile} -L ${logFiles} -${levelFlag} -m ${cfg.mailTo}";

  levelFlag = getAttrFromPath [cfg.level]
    { "paranoid"    = "p";
      "server"      = "s";
      "workstation" = "w";
    };

  cronJob = ''
    @reboot   logcheck env PATH=/var/setuid-wrappers:$PATH nice -n10 ${pkgs.logcheck}/sbin/logcheck -R ${flags}
    2 ${cfg.timeOfDay} * * * logcheck env PATH=/var/setuid-wrappers:$PATH nice -n10 ${pkgs.logcheck}/sbin/logcheck ${flags}
  '';

in
{
  options = {
    services.logcheck = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable the logcheck cron job.
        '';
      };

      user = mkOption {
        default = "logcheck";
        type = types.uniq types.string;
        description = ''
          Username for the logcheck user.
        '';
      };

      timeOfDay = mkOption {
        default = "*";
        example = "6";
        type = types.uniq types.string;
        description = ''
          Time of day to run logcheck. A logcheck will be scheduled at xx:02 each day.
          Leave default (*) to run every hour. Of course when nothing special was logged,
          logcheck will be silent.
        '';
      };

      mailTo = mkOption {
        default = "root";
        example = "you@domain.com";
        type = types.uniq types.string;
        description = ''
          Email address to send reports to.
        '';
      };

      level = mkOption {
        default = "server";
        type = types.uniq types.string;
        description = ''
          Set the logcheck level. Either "workstation", "server", or "paranoid".
        '';
      };

      config = mkOption {
        default = "FQDN=1";
        type = types.string;
        description = ''
          Config options that you would like in logcheck.conf.
        '';
      };

      files = mkOption {
        default = [ "/var/log/messages" ];
        type = types.listOf types.path;
        example = [ "/var/log/messages" "/var/log/mail" ];
        description = ''
          Which log files to check.
        '';
      };

      extraRulesDir = mkOption {
        default = null;
        example = "/etc/logcheck";
        type = types.nullOr types.path;
        description = ''
          Directory with extra rules.
          Will be merged with bundled rules, so it's possible to override certain behaviour.
        '';
      };

      extraGroups = mkOption {
        default = [];
        type = types.listOf types.string;
        example = [ "postdrop" "mongodb" ];
        description = ''
          Extra groups for the logcheck user, for example to be able to use sendmail,
          or to access certain log files.
        '';
      };

    };
  };

  config = mkIf cfg.enable {
    users.extraUsers = singleton
      { name = cfg.user;
        shell = "/bin/sh";
        description = "Logcheck user account";
        extraGroups = cfg.extraGroups;
      };

    system.activationScripts.logcheck = ''
      mkdir -m 700 -p /var/{lib,lock}/logcheck
      chown ${cfg.user} /var/{lib,lock}/logcheck
    '';

    services.cron.systemCronJobs = [ cronJob ];
  };
}
