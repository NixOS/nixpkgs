{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.avahi;

  yesNo = yes: if yes then "yes" else "no";

  avahiDaemonConf =
    with cfg;
    pkgs.writeText "avahi-daemon.conf" ''
      [server]
      ${
        # Users can set `networking.hostName' to the empty string, when getting
        # a host name from DHCP.  In that case, let Avahi take whatever the
        # current host name is; setting `host-name' to the empty string in
        # `avahi-daemon.conf' would be invalid.
        lib.optionalString (hostName != "") "host-name=${hostName}"
      }
      browse-domains=${lib.concatStringsSep ", " browseDomains}
      use-ipv4=${yesNo ipv4}
      use-ipv6=${yesNo ipv6}
      ${lib.optionalString (
        allowInterfaces != null
      ) "allow-interfaces=${lib.concatStringsSep "," allowInterfaces}"}
      ${lib.optionalString (
        denyInterfaces != null
      ) "deny-interfaces=${lib.concatStringsSep "," denyInterfaces}"}
      ${lib.optionalString (domainName != null) "domain-name=${domainName}"}
      allow-point-to-point=${yesNo allowPointToPoint}
      ${lib.optionalString (cacheEntriesMax != null) "cache-entries-max=${toString cacheEntriesMax}"}

      [wide-area]
      enable-wide-area=${yesNo wideArea}

      [publish]
      disable-publishing=${yesNo (!publish.enable)}
      disable-user-service-publishing=${yesNo (!publish.userServices)}
      publish-addresses=${yesNo (publish.userServices || publish.addresses)}
      publish-hinfo=${yesNo publish.hinfo}
      publish-workstation=${yesNo publish.workstation}
      publish-domain=${yesNo publish.domain}

      [reflector]
      enable-reflector=${yesNo reflector}
      ${extraConfig}
    '';
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "avahi" "interfaces" ]
      [ "services" "avahi" "allowInterfaces" ]
    )
    (lib.mkRenamedOptionModule [ "services" "avahi" "nssmdns" ] [ "services" "avahi" "nssmdns4" ])
  ];

  options.services.avahi = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to run the Avahi daemon, which allows Avahi clients
        to use Avahi's service discovery facilities and also allows
        the local machine to advertise its presence and services
        (through the mDNS responder implemented by `avahi-daemon`).
      '';
    };

    package = lib.mkPackageOption pkgs "avahi" { };

    hostName = lib.mkOption {
      type = lib.types.str;
      default = config.networking.hostName;
      defaultText = lib.literalExpression "config.networking.hostName";
      description = ''
        Host name advertised on the LAN. If not set, avahi will use the value
        of {option}`config.networking.hostName`.
      '';
    };

    domainName = lib.mkOption {
      type = lib.types.str;
      default = "local";
      description = ''
        Domain name for all advertisements.
      '';
    };

    browseDomains = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "0pointer.de"
        "zeroconf.org"
      ];
      description = ''
        List of non-local DNS domains to be browsed.
      '';
    };

    ipv4 = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to use IPv4.";
    };

    ipv6 = lib.mkOption {
      type = lib.types.bool;
      default = config.networking.enableIPv6;
      defaultText = lib.literalExpression "config.networking.enableIPv6";
      description = "Whether to use IPv6.";
    };

    allowInterfaces = lib.mkOption {
      type = lib.types.nullOr (lib.types.listOf lib.types.str);
      default = null;
      description = ''
        List of network interfaces that should be used by the {command}`avahi-daemon`.
        Other interfaces will be ignored. If `null`, all local interfaces
        except loopback and point-to-point will be used.
      '';
    };

    denyInterfaces = lib.mkOption {
      type = lib.types.nullOr (lib.types.listOf lib.types.str);
      default = null;
      description = ''
        List of network interfaces that should be ignored by the
        {command}`avahi-daemon`. Other unspecified interfaces will be used,
        unless {option}`allowInterfaces` is set. This option takes precedence
        over {option}`allowInterfaces`.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to open the firewall for UDP port 5353.
        Disabling this setting also disables discovering of network devices.
      '';
    };

    allowPointToPoint = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to use POINTTOPOINT interfaces. Might make mDNS unreliable due to usually large
        latencies with such links and opens a potential security hole by allowing mDNS access from Internet
        connections.
      '';
    };

    wideArea = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable wide-area service discovery.";
    };

    reflector = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Reflect incoming mDNS requests to all allowed network interfaces.";
    };

    extraServiceFiles = lib.mkOption {
      type = with lib.types; attrsOf (either str path);
      default = { };
      example = lib.literalExpression ''
        {
          ssh = "''${pkgs.avahi}/etc/avahi/services/ssh.service";
          smb = '''
            <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
            <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
            <service-group>
              <name replace-wildcards="yes">%h</name>
              <service>
                <type>_smb._tcp</type>
                <port>445</port>
              </service>
            </service-group>
          ''';
        }
      '';
      description = ''
        Specify custom service definitions which are placed in the avahi service directory.
        See the {manpage}`avahi.service(5)` manpage for detailed information.
      '';
    };

    publish = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to allow publishing in general.";
      };

      userServices = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to publish user services. Will set `addresses=true`.";
      };

      addresses = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to register mDNS address records for all local IP addresses.";
      };

      hinfo = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to register a mDNS HINFO record which contains information about the
          local operating system and CPU.
        '';
      };

      workstation = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to register a service of type "_workstation._tcp" on the local LAN.
        '';
      };

      domain = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to announce the locally used domain name for browsing by other hosts.";
      };
    };

    nssmdns4 = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable the mDNS NSS (Name Service Switch) plug-in for IPv4.
        Enabling it allows applications to resolve names in the `.local`
        domain by transparently querying the Avahi daemon.
      '';
    };

    nssmdns6 = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable the mDNS NSS (Name Service Switch) plug-in for IPv6.
        Enabling it allows applications to resolve names in the `.local`
        domain by transparently querying the Avahi daemon.

        ::: {.note}
        Due to the fact that most mDNS responders only register local IPv4 addresses,
        most user want to leave this option disabled to avoid long timeouts when applications first resolve the none existing IPv6 address.
        :::
      '';
    };

    cacheEntriesMax = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = ''
        Number of resource records to be cached per interface. Use 0 to
        disable caching. Avahi daemon defaults to 4096 if not set.
      '';
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Extra config to append to avahi-daemon.conf.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.avahi = {
      description = "avahi-daemon privilege separation user";
      home = "/var/empty";
      group = "avahi";
      isSystemUser = true;
    };

    users.groups.avahi = { };

    system.nssModules = lib.optional (cfg.nssmdns4 || cfg.nssmdns6) pkgs.nssmdns;
    system.nssDatabases.hosts =
      let
        mdns =
          if (cfg.nssmdns4 && cfg.nssmdns6) then
            "mdns"
          else if (!cfg.nssmdns4 && cfg.nssmdns6) then
            "mdns6"
          else if (cfg.nssmdns4 && !cfg.nssmdns6) then
            "mdns4"
          else
            "";
      in
      lib.optionals (cfg.nssmdns4 || cfg.nssmdns6) (
        lib.mkMerge [
          (lib.mkBefore [ "${mdns}_minimal [NOTFOUND=return]" ]) # before resolve
          (lib.mkAfter [ "${mdns}" ]) # after dns
        ]
      );

    environment.systemPackages = [ cfg.package ];

    environment.etc = (
      lib.mapAttrs' (
        n: v:
        lib.nameValuePair "avahi/services/${n}.service" {
          ${if lib.types.path.check v then "source" else "text"} = v;
        }
      ) cfg.extraServiceFiles
    );

    systemd.sockets.avahi-daemon = {
      description = "Avahi mDNS/DNS-SD Stack Activation Socket";
      listenStreams = [ "/run/avahi-daemon/socket" ];
      wantedBy = [ "sockets.target" ];
      after = [
        # Ensure that `/run/avahi-daemon` owned by `avahi` is created by `systemd.tmpfiles.rules` before the `avahi-daemon.socket`,
        # otherwise `avahi-daemon.socket` will automatically create it owned by `root`, which will cause `avahi-daemon.service` to fail.
        "systemd-tmpfiles-setup.service"
      ];
    };

    systemd.tmpfiles.rules = [ "d /run/avahi-daemon - avahi avahi -" ];

    systemd.services.avahi-daemon = {
      description = "Avahi mDNS/DNS-SD Stack";
      wantedBy = [ "multi-user.target" ];
      requires = [ "avahi-daemon.socket" ];
      documentation = [
        "man:avahi-daemon(8)"
        "man:avahi-daemon.conf(5)"
        "man:avahi.hosts(5)"
        "man:avahi.service(5)"
      ];

      # Make NSS modules visible so that `avahi_nss_support ()' can
      # return a sensible value.
      environment.LD_LIBRARY_PATH = config.system.nssModules.path;

      path = [
        pkgs.coreutils
        cfg.package
      ];

      serviceConfig = {
        NotifyAccess = "main";
        BusName = "org.freedesktop.Avahi";
        Type = "dbus";
        ExecStart = "${cfg.package}/sbin/avahi-daemon --syslog -f ${avahiDaemonConf}";
        ConfigurationDirectory = "avahi/services";

        # Hardening
        CapabilityBoundingSet = [
          # https://github.com/avahi/avahi/blob/v0.9-rc1/avahi-daemon/caps.c#L38
          "CAP_SYS_CHROOT"
          "CAP_SETUID"
          "CAP_SETGID"
        ];
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = false;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "@chown setgroups setresuid"
        ];
        UMask = "0077";
      };
    };

    services.dbus.enable = true;
    services.dbus.packages = [ cfg.package ];

    networking.firewall.allowedUDPPorts = lib.mkIf cfg.openFirewall [ 5353 ];
  };
}
