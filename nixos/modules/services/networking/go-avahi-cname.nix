{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.go-avahi-cname;
in
{
  options.services.go-avahi-cname = {
    enable = lib.mkEnableOption "go-avahi-cname";

    package = lib.mkPackageOption pkgs "go-avahi-cname" { };

    mode = lib.mkOption {
      type = lib.types.enum [
        "interval-publishing"
        "subdomain-reply"
      ];
      default = "subdomain-reply";
      example = "interval-publishing";
      description = ''
        The mode of operation for the mDNS subdomain publisher.

        - "subdomain-reply": Responds to the incoming DNS queries for subdomains
          (e.g. `name.hostname.local`) with a CNAME pointing to the base domain.

        - "interval-publishing": Periodically broadcasts CNAME records for the
          specified subdomains to the network using mDNS.
      '';
    };

    ttl = lib.mkOption {
      type = lib.types.ints.positive;
      default = 600;
      example = 300;
      description = "The Time to Live (TTL) of the CNAME records in seconds.";
    };

    fqdn = lib.mkOption {
      type = lib.types.str;
      default = "${config.networking.hostName}.local.";
      defaultText = lib.literalExpression "<config.networking.hostName>.local";
      example = "printer.local.";
      description = "The Fully Qualified Domain Name (FQDN) that is used for the CNAME record.";
    };

    interval = lib.mkOption {
      type = lib.types.ints.positive;
      default = 300;
      example = 150;
      description = ''
        The period in seconds to publish CNAME records to the network.
        Only used when the mode is set to "interval-publishing".
      '';
    };

    subdomains = lib.mkOption {
      type = lib.types.nonEmptyListOf lib.types.str;
      example = [ "git" ];
      description = ''
        The list of subdomains to be published.

        For example, if `git` is specified on a device with a hostname `lab`,
        the request for `git.lab.local` will be redirected to `lab.local`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.packages = [ cfg.package ];

    systemd.services.go-avahi-cname = {
      description = "Go Avahi CNAME Publisher";
      after = [
        "dbus.service"
        "avahi-daemon.service"
        "network-online.target"
      ];
      requires = [
        "dbus.service"
        "avahi-daemon.service"
        "network-online.target"
      ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig =
        let
          flags = lib.concatStringsSep " " (
            [
              (if cfg.mode == "interval-publishing" then "cname" else "subdomain")
              "--ttl ${toString cfg.ttl}"
              "--fqdn ${lib.escapeShellArg cfg.fqdn}"
            ]
            ++ lib.optional (cfg.mode == "interval-publishing") "--interval ${toString cfg.interval}"
            ++ map lib.escapeShellArg cfg.subdomains
          );
        in
        {
          CapabilityBoundingSet = "";
          DynamicUser = true;
          ExecStart = "${lib.getExe cfg.package} ${flags}";
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          PrivateDevices = true;
          PrivateTmp = true;
          PrivateUsers = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostName = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = true;
          ProtectSystem = true;
          UMask = "0027";
          Restart = "on-failure";
          RestartSec = 10;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          SupplementaryGroups = [
            "avahi"
            "messagebus"
          ];
          StartLimitBurst = 3;
        };
    };
  };

  meta = {
    doc = ./go-avahi-cname.md;
    maintainers = with lib.maintainers; [ magicquark ];
  };
}
