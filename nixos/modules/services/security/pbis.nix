{ config, lib, pkgs, ... }:
let
  cfg = config.services.pbis;
  pbis = cfg.package;
  inherit (builtins) isBool isList isString;
  inherit (lib) mkIf mkDefault mkOption mkEnableOption types;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.lists) optional;
  inherit (lib.strings) concatStringsSep concatMapStringsSep escapeShellArg optionalString;
in
{
  options.services.pbis = with types; {

    enable = mkEnableOption "BeyondTrust AD Bridge Open (ActiveDirectory client)";

    package = mkOption {
      type = package;
      default = pkgs.pbis-open;
      example = pkgs.pbis-open;
      description = "The PBIS package to use. Useful when you want different compile-time options.";
    };

    domainJoin = {
      domain = mkOption {
        type = str;
        example = "example.com";
        description = "The domain name to join (base DN).";
      };

      userName = mkOption {
        type = str;
        example = "admin@example.com";
        description = "The domain user name (bind DN).";
      };

      passwordFile = mkOption {
        type = nullOr (either path str);
        example = "/var/lib/pbis/bind.passwd";
        default = null;
        description = ''
          The filepath which contains domain user plaintext password (bind DN password).
          If omitted, password is not specified.
          WARNING: if passwordFile is not configured to be persistent on disk
          (especially under /run/keys with NixOps), you may be LOCKED OUT after reboot.
          Place passwordFile in secure and persistent path.
        '';
      };

      extraOptions = mkOption {
        type = listOf str;
        example = [ "--notimesync" ];
        default = [];
        description = "Extra command line options that are passed to `domainjoin-cli join`.";
      };
    };

    ignoreUsers = mkOption {
      type = listOf str;
      example = [ "root" "nginx" ];
      default = [ "root" ];
      description = "Special users who should bypass AD to login.";
    };

    ignoreGroups = mkOption {
      type = listOf str;
      example = [ "root" "tty" "wheel" ];
      default = [ "root" "tty" ];
      description = "Special user groups which should bypass AD to login.";
    };

    config = mkOption {
      type = attrs;
      example = {
        AssumeDefaultDomain = true;
        UserDomainPrefix = "example.com";
        LoginShellTemplate = "/run/current-system/sw/bin/bash";
        RequireMembershipOf = [ ''MyOrg/Admins'' ''MyOrg\MyTeam'' ];
        SyncSystemTime = false;
      };
      description = ''
        Sequence of setup subcommands to feed to `$${cfg.package}/bin/config`.
        Find available options in Configuration Tool Reference Guide PDF of AD Bridge Documentation.
        https://www.beyondtrust.com/docs/ad-bridge/documents/adb-config-tool-reference-guide.pdf
      '';
    };
  };

  config = mkIf cfg.enable {

    systemd.services.lwsmd = {
      description = "BeyondTrust AD Bridge PBIS Service Manager";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "forking";
        ExecStart = "${pbis}/bin/lwsmd --start-as-daemon";
        StateDirectory = [ "pbis" ];
        Restart = mkDefault "always";
        TemporaryFileSystem = "/opt:mode=777"; # See below
      };

      # taken from sssd
      before = [ "systemd-user-sessions.service" "nss-user-lookup.target" ];
      after = [ "network-online.target" "nscd.service" ];
      requires = [ "network-online.target" "nscd.service" ];
      wants = [ "nss-user-lookup.target" ];
      restartTriggers = [ config.environment.etc."nscd.conf".source ];

      preStart = ''
        set -x
        # This is evil but I could not find any workaround that
        # lwsmd trying to load /opt/pbis/lib/lw-svcm/eventlog.so
        # NIX_REDIRECTS tweak also did not work.
        ln -snf ${pbis} /opt/pbis

        # Setup registry (adapted from deb package's postinst)
        cp -af ${pbis.sys}/var/lib/pbis/lw{config,report}.xml /var/lib/pbis/
        ${pbis}/bin/lwsmd --start-as-daemon --disable-autostart
        REGSHELL=${pbis}/bin/regshell
        for i in "${pbis}/share/config/"*.reg; do
          $REGSHELL import "$i"
          $REGSHELL cleanup "$i"
        done
        $REGSHELL set_value '[HKEY_THIS_MACHINE\Services\lwio\Parameters\Drivers]' 'Load' 'rdr'
        $REGSHELL set_value '[HKEY_THIS_MACHINE\Services\lsass]' 'Dependencies' 'netlogon lwio lwreg rdr'
        $REGSHELL set_value '[HKEY_THIS_MACHINE\Services\eventlog]' 'Dependencies' ""
        $REGSHELL set_value '[HKEY_THIS_MACHINE\Services\dcerpc]' 'Arguments' ""
        $REGSHELL set_value '[HKEY_THIS_MACHINE\Services\lsass\Parameters\Providers\ActiveDirectory]' Path '${cfg.package}/lib/lsa-provider/ad_open.so'
        ${pbis}/bin/lwsm shutdown
      '';

      postStart = with cfg.domainJoin; ''
        ${pbis}/bin/pbis-status | grep "Unknown" >/dev/null && {
          ${pbis}/bin/domainjoin-cli join ${toString extraOptions} \
            ${escapeShellArg domain} \
            ${escapeShellArg userName} \
            ${optionalString (passwordFile != null) "$(cat ${passwordFile})"} \
            >/dev/null 2>&1 || true
            # ^ignore errors: pbis's stateful behavior (change PAM module and conf) cause some errors
        }
        ${pbis}/bin/ad-cache --delete-all
        ${ let convertValue = v:
                 if isBool v then (if v then "true" else "false")
                 else if isList v then toString (map escapeShellArg v)
                 else if isString v then escapeShellArg v
                 else toString v;
               escapedArgsList = mapAttrsToList (key: value: "${escapeShellArg key} ${convertValue value}") cfg.config;
           in concatMapStringsSep "\n" (args: "${pbis}/bin/config " + args) escapedArgsList
         }
      '';
    };

    # Add pbis-sys/lib(/libnss_lsass.so.2) to sshd's LD_LIBRARY_PATH.
    system.nssModules = optional cfg.enable cfg.package.sys;

    environment.etc."pbis/user-ignore".text = concatStringsSep "\n" cfg.ignoreUsers;
    environment.etc."pbis/group-ignore".text = concatStringsSep "\n" cfg.ignoreGroups;
  };
}
