{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  cfg = config.services.incron;

in

{
  options = {

    services.incron = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the incron daemon.

          Note that commands run under incrontab only support common Nix profiles for the {env}`PATH` provided variable.
        '';
      };

      allow = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
        description = ''
          Users allowed to use incrontab.

          If empty then no user will be allowed to have their own incrontab.
          If `null` then will defer to {option}`deny`.
          If both {option}`allow` and {option}`deny` are null
          then all users will be allowed to have their own incrontab.
        '';
      };

      deny = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
        description = "Users forbidden from using incrontab.";
      };

      systab = mkOption {
        type = types.lines;
        default = "";
        description = "The system incrontab contents.";
        example = ''
          /var/mail IN_CLOSE_WRITE abc $@/$#
          /tmp IN_ALL_EVENTS efg $@/$# $&
        '';
      };

      extraPackages = mkOption {
        type = types.listOf types.package;
        default = [ ];
        example = literalExpression "[ pkgs.rsync ]";
        description = "Extra packages available to the system incrontab.";
      };

    };

  };

  config = mkIf cfg.enable {

    warnings = optional (
      cfg.allow != null && cfg.deny != null
    ) "If `services.incron.allow` is set then `services.incron.deny` will be ignored.";

    environment.systemPackages = [ pkgs.incron ];

    security.wrappers.incrontab = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${pkgs.incron}/bin/incrontab";
    };

    # incron won't read symlinks
    environment.etc."incron.d/system" = {
      mode = "0444";
      text = cfg.systab;
    };
    environment.etc."incron.allow" = mkIf (cfg.allow != null) {
      text = concatStringsSep "\n" cfg.allow;
    };
    environment.etc."incron.deny" = mkIf (cfg.deny != null) {
      text = concatStringsSep "\n" cfg.deny;
    };

    systemd.services.incron = {
      description = "File System Events Scheduler";
      wantedBy = [ "multi-user.target" ];
      path = cfg.extraPackages;
      serviceConfig.PIDFile = "/run/incrond.pid";
      serviceConfig.ExecStartPre = "${pkgs.coreutils}/bin/mkdir -m 710 -p /var/spool/incron";
      serviceConfig.ExecStart = "${pkgs.incron}/bin/incrond --foreground";
    };
  };

}
