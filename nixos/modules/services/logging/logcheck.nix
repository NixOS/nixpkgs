{config, pkgs, ...}:

with pkgs.lib;

let
  cfg = config.services.logcheck;

  defaultRules = pkgs.runCommand "logcheck-default-rules" {} ''
                   cp -prd ${pkgs.logcheck}/etc/logcheck $out
                   chmod u+w $out
                   rm $out/logcheck.*
                 '';

  rulesDir = pkgs.symlinkJoin "logcheck-rules-dir" ([ defaultRules ] ++ cfg.extraRulesDirs);

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

  writeIgnoreRule = name: {level, regex, ...}:
    pkgs.writeTextFile
      { inherit name;
        destination = "/ignore.d.${level}/${name}";
        text = ''
          ^\w{3} [ :[:digit:]]{11} [._[:alnum:]-]+ ${regex}
        '';
      };

  writeIgnoreCronRule = name: {level, user, regex, cmdline, ...}:
    let escapeRegex = escape (stringToCharacters "\\[]{}()^$?*+|.");
        cmdline_ = builtins.unsafeDiscardStringContext cmdline;
        re = if regex != "" then regex else if cmdline_ == "" then ".*" else escapeRegex cmdline_;
    in writeIgnoreRule "cron-${name}" {
      inherit level;
      regex = ''
        (/usr/bin/)?cron\[[0-9]+\]: \(${user}\) CMD \(${re}\)$
      '';
    };

  levelOption = mkOption {
    default = "server";
    type = types.str;
    description = ''
      Set the logcheck level. Either "workstation", "server", or "paranoid".
    '';
  };

  ignoreOptions = {
    level = levelOption;

    regex = mkOption {
      default = "";
      type = types.str;
      description = ''
        Regex specifying which log lines to ignore.
      '';
    };
  };

  ignoreCronOptions = {
    user = mkOption {
      default = "root";
      type = types.str;
      description = ''
        User that runs the cronjob.
      '';
    };

    cmdline = mkOption {
      default = "";
      type = types.str;
      description = ''
        Command line for the cron job. Will be turned into a regex for the logcheck ignore rule.
      '';
    };

    timeArgs = mkOption {
      default = null;
      type = types.nullOr (types.str);
      example = "02 06 * * *";
      description = ''
        "min hr dom mon dow" crontab time args, to auto-create a cronjob too.
        Leave at null to not do this and just add a logcheck ignore rule.
      '';
    };
  };

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
        type = types.str;
        description = ''
          Username for the logcheck user.
        '';
      };

      timeOfDay = mkOption {
        default = "*";
        example = "6";
        type = types.str;
        description = ''
          Time of day to run logcheck. A logcheck will be scheduled at xx:02 each day.
          Leave default (*) to run every hour. Of course when nothing special was logged,
          logcheck will be silent.
        '';
      };

      mailTo = mkOption {
        default = "root";
        example = "you@domain.com";
        type = types.str;
        description = ''
          Email address to send reports to.
        '';
      };

      level = mkOption {
        default = "server";
        type = types.str;
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

      extraRulesDirs = mkOption {
        default = [];
        example = "/etc/logcheck";
        type = types.listOf types.path;
        description = ''
          Directories with extra rules.
        '';
      };

      ignore = mkOption {
        default = {};
        description = ''
          This option defines extra ignore rules.
        '';
        type = types.loaOf types.optionSet;
        options = [ ignoreOptions ];
      };

      ignoreCron = mkOption {
        default = {};
        description = ''
          This option defines extra ignore rules for cronjobs.
        '';
        type = types.loaOf types.optionSet;
        options = [ ignoreOptions ignoreCronOptions ];
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
    services.logcheck.extraRulesDirs =
        mapAttrsToList writeIgnoreRule cfg.ignore
        ++ mapAttrsToList writeIgnoreCronRule cfg.ignoreCron;

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

    services.cron.systemCronJobs =
        let withTime = name: {timeArgs, ...}: ! (builtins.isNull timeArgs);
            mkCron = name: {user, cmdline, timeArgs, ...}: ''
              ${timeArgs} ${user} ${cmdline}
            '';
        in mapAttrsToList mkCron (filterAttrs withTime cfg.ignoreCron)
           ++ [ cronJob ];
  };
}
