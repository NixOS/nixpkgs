{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.logcheck;

  defaultRules = pkgs.runCommand "logcheck-default-rules" { preferLocalBuild = true; } ''
                   cp -prd ${pkgs.logcheck}/etc/logcheck $out
                   chmod u+w $out
                   rm -r $out/logcheck.*
                 '';

  rulesDir = pkgs.symlinkJoin
    { name = "logcheck-rules-dir";
      paths = ([ defaultRules ] ++ cfg.extraRulesDirs);
    };

  configFile = pkgs.writeText "logcheck.conf" cfg.config;

  logFiles = pkgs.writeText "logcheck.logfiles" cfg.files;

  flags = "-r ${rulesDir} -c ${configFile} -L ${logFiles} -${levelFlag} -m ${cfg.mailTo}";

  levelFlag = getAttrFromPath [cfg.level]
    { paranoid    = "p";
      server      = "s";
      workstation = "w";
    };

  cronJob = ''
    @reboot   logcheck env PATH=/run/wrappers/bin:$PATH nice -n10 ${pkgs.logcheck}/sbin/logcheck -R ${flags}
    2 ${cfg.timeOfDay} * * * logcheck env PATH=/run/wrappers/bin:$PATH nice -n10 ${pkgs.logcheck}/sbin/logcheck ${flags}
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
    type = types.enum [ "workstation" "server" "paranoid" ];
    description = ''
      Set the logcheck level.
    '';
  };

  ignoreOptions = {
    options = {
      level = levelOption;

      regex = mkOption {
        default = "";
        type = types.str;
        description = ''
          Regex specifying which log lines to ignore.
        '';
      };
    };
  };

  ignoreCronOptions = {
    options = {
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
  };

in
{
  options = {
    services.logcheck = {
      enable = mkEnableOption "logcheck cron job, to mail anomalies in the system logfiles to the administrator";

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
        type = types.lines;
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
        example = [ "/etc/logcheck" ];
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
        type = with types; attrsOf (submodule ignoreOptions);
      };

      ignoreCron = mkOption {
        default = {};
        description = ''
          This option defines extra ignore rules for cronjobs.
        '';
        type = with types; attrsOf (submodule ignoreCronOptions);
      };

      extraGroups = mkOption {
        default = [];
        type = types.listOf types.str;
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

    users.users = optionalAttrs (cfg.user == "logcheck") {
      logcheck = {
        group = "logcheck";
        isSystemUser = true;
        shell = "/bin/sh";
        description = "Logcheck user account";
        extraGroups = cfg.extraGroups;
      };
    };
    users.groups = optionalAttrs (cfg.user == "logcheck") {
      logcheck = {};
    };

    systemd.tmpfiles.settings.logcheck = {
      "/var/lib/logcheck".d = {
        mode = "700";
        inherit (cfg) user;
      };
      "/var/lock/logcheck".d = {
        mode = "700";
        inherit (cfg) user;
      };
    };

    services.cron.systemCronJobs =
        let withTime = name: {timeArgs, ...}: timeArgs != null;
            mkCron = name: {user, cmdline, timeArgs, ...}: ''
              ${timeArgs} ${user} ${cmdline}
            '';
        in mapAttrsToList mkCron (filterAttrs withTime cfg.ignoreCron)
           ++ [ cronJob ];
  };
}
