{
  config,
  lib,
  pkgs,
  ...
}:
let

  nssModulesPath = config.system.nssModules.path;
  cfg = config.services.nscd;

in

{

  ###### interface

  options = {

    services.nscd = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to enable the Name Service Cache Daemon.
          Disabling this is strongly discouraged, as this effectively disables NSS Lookups
          from all non-glibc NSS modules, including the ones provided by systemd.
        '';
      };

      enableNsncd = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to use nsncd instead of nscd from glibc.
          This is a nscd-compatible daemon, that proxies lookups, without any caching.
          Using nscd from glibc is discouraged.
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "nscd";
        description = ''
          User account under which nscd runs.
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "nscd";
        description = ''
          User group under which nscd runs.
        '';
      };

      config = lib.mkOption {
        type = lib.types.lines;
        default = builtins.readFile ./nscd.conf;
        description = ''
          Configuration to use for Name Service Cache Daemon.
          Only used in case glibc-nscd is used.
        '';
      };

      package = lib.mkOption {
        type = lib.types.package;
        default =
          if pkgs.stdenv.hostPlatform.libc == "glibc" then pkgs.stdenv.cc.libc.bin else pkgs.glibc.bin;
        defaultText = lib.literalExpression ''
          if pkgs.stdenv.hostPlatform.libc == "glibc"
            then pkgs.stdenv.cc.libc.bin
            else pkgs.glibc.bin;
        '';
        description = ''
          package containing the nscd binary to be used by the service.
          Ignored when enableNsncd is set to true.
        '';
      };

    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    environment.etc."nscd.conf".text = cfg.config;

    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
    };

    users.groups.${cfg.group} = { };

    systemd.services.nscd = {
      description = "Name Service Cache Daemon" + lib.optionalString cfg.enableNsncd " (nsncd)";

      before = [
        "nss-lookup.target"
        "nss-user-lookup.target"
      ];
      wants = [
        "nss-lookup.target"
        "nss-user-lookup.target"
      ];
      wantedBy = [ "multi-user.target" ];
      requiredBy = [
        "nss-lookup.target"
        "nss-user-lookup.target"
      ];

      environment = {
        LD_LIBRARY_PATH = nssModulesPath;
      };

      restartTriggers = lib.optionals (!cfg.enableNsncd) (
        [
          config.environment.etc.hosts.source
          config.environment.etc."nsswitch.conf".source
          config.environment.etc."nscd.conf".source
        ]
        ++ lib.optionals config.users.mysql.enable [
          config.environment.etc."libnss-mysql.cfg".source
          config.environment.etc."libnss-mysql-root.cfg".source
        ]
      );

      # In some configurations, nscd needs to be started as root; it will
      # drop privileges after all the NSS modules have read their
      # configuration files. So prefix the ExecStart command with "!" to
      # prevent systemd from dropping privileges early. See ExecStart in
      # systemd.service(5). We use a static user, because some NSS modules
      # sill want to read their configuration files after the privilege drop
      # and so users can set the owner of those files to the nscd user.
      serviceConfig = {
        ExecStart = if cfg.enableNsncd then "${pkgs.nsncd}/bin/nsncd" else "!@${cfg.package}/bin/nscd nscd";
        Type = if cfg.enableNsncd then "notify" else "forking";
        User = cfg.user;
        Group = cfg.group;
        RemoveIPC = true;
        PrivateTmp = true;
        # https://github.com/twosigma/nsncd/pull/33/files#r1496927653
        Environment = [ "NSNCD_HANDOFF_TIMEOUT=10" ];
        NoNewPrivileges = true;
        RestrictSUIDSGID = true;
        ProtectSystem = "strict";
        ProtectHome = "read-only";
        RuntimeDirectory = "nscd";
        PIDFile = "/run/nscd/nscd.pid";
        Restart = "always";
        ExecReload = lib.optionals (!cfg.enableNsncd) [
          "${cfg.package}/bin/nscd --invalidate passwd"
          "${cfg.package}/bin/nscd --invalidate group"
          "${cfg.package}/bin/nscd --invalidate hosts"
        ];
      };
    };
  };
}
