{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.incron;

in

{
  options = {

    services.incron = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable the incron daemon.

          Note that commands run under incrontab only support common Nix profiles for the {env}`PATH` provided variable.
        '';
      };

      allow = lib.mkOption {
        type = lib.types.nullOr (lib.types.listOf lib.types.str);
        default = null;
        description = ''
          Users allowed to use incrontab.

          If empty then no user will be allowed to have their own incrontab.
          If `null` then will defer to {option}`deny`.
          If both {option}`allow` and {option}`deny` are null
          then all users will be allowed to have their own incrontab.
        '';
      };

      deny = lib.mkOption {
        type = lib.types.nullOr (lib.types.listOf lib.types.str);
        default = null;
        description = "Users forbidden from using incrontab.";
      };

      systab = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "The system incrontab contents.";
        example = ''
          /var/mail IN_CLOSE_WRITE abc $@/$#
          /tmp IN_ALL_EVENTS efg $@/$# $&
        '';
      };

      extraPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        example = lib.literalExpression "[ pkgs.rsync ]";
        description = "Extra packages available to the system incrontab.";
      };

    };

  };

  config = lib.mkIf cfg.enable {

    warnings = lib.optional (
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
    environment.etc."incron.allow" = lib.mkIf (cfg.allow != null) {
      text = lib.concatStringsSep "\n" cfg.allow;
    };
    environment.etc."incron.deny" = lib.mkIf (cfg.deny != null) {
      text = lib.concatStringsSep "\n" cfg.deny;
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
