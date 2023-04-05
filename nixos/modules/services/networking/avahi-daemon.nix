{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.avahi;

  yesNo = yes: if yes then "yes" else "no";

  avahiDaemonConf = with cfg; pkgs.writeText "avahi-daemon.conf" ''
    [server]
    ${# Users can set `networking.hostName' to the empty string, when getting
      # a host name from DHCP.  In that case, let Avahi take whatever the
      # current host name is; setting `host-name' to the empty string in
      # `avahi-daemon.conf' would be invalid.
      optionalString (hostName != "") "host-name=${hostName}"}
    browse-domains=${concatStringsSep ", " browseDomains}
    use-ipv4=${yesNo ipv4}
    use-ipv6=${yesNo ipv6}
    ${optionalString (allowInterfaces!=null) "allow-interfaces=${concatStringsSep "," allowInterfaces}"}
    ${optionalString (denyInterfaces!=null) "deny-interfaces=${concatStringsSep "," denyInterfaces}"}
    ${optionalString (domainName!=null) "domain-name=${domainName}"}
    allow-point-to-point=${yesNo allowPointToPoint}
    ${optionalString (cacheEntriesMax!=null) "cache-entries-max=${toString cacheEntriesMax}"}

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
    (lib.mkRenamedOptionModule [ "services" "avahi" "interfaces" ] [ "services" "avahi" "allowInterfaces" ])
  ];

  options.services.avahi = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to run the Avahi daemon, which allows Avahi clients
        to use Avahi's service discovery facilities and also allows
        the local machine to advertise its presence and services
        (through the mDNS responder implemented by `avahi-daemon`).
      '';
    };

    hostName = mkOption {
      type = types.str;
      default = config.networking.hostName;
      defaultText = literalExpression "config.networking.hostName";
      description = lib.mdDoc ''
        Host name advertised on the LAN. If not set, avahi will use the value
        of {option}`config.networking.hostName`.
      '';
    };

    domainName = mkOption {
      type = types.str;
      default = "local";
      description = lib.mdDoc ''
        Domain name for all advertisements.
      '';
    };

    browseDomains = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "0pointer.de" "zeroconf.org" ];
      description = lib.mdDoc ''
        List of non-local DNS domains to be browsed.
      '';
    };

    ipv4 = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc "Whether to use IPv4.";
    };

    ipv6 = mkOption {
      type = types.bool;
      default = config.networking.enableIPv6;
      defaultText = literalExpression "config.networking.enableIPv6";
      description = lib.mdDoc "Whether to use IPv6.";
    };

    allowInterfaces = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
      description = lib.mdDoc ''
        List of network interfaces that should be used by the {command}`avahi-daemon`.
        Other interfaces will be ignored. If `null`, all local interfaces
        except loopback and point-to-point will be used.
      '';
    };

    denyInterfaces = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
      description = lib.mdDoc ''
        List of network interfaces that should be ignored by the
        {command}`avahi-daemon`. Other unspecified interfaces will be used,
        unless {option}`allowInterfaces` is set. This option takes precedence
        over {option}`allowInterfaces`.
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        Whether to open the firewall for UDP port 5353.
        Disabling this setting also disables discovering of network devices.
      '';
    };

    allowPointToPoint = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to use POINTTOPOINT interfaces. Might make mDNS unreliable due to usually large
        latencies with such links and opens a potential security hole by allowing mDNS access from Internet
        connections.
      '';
    };

    wideArea = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc "Whether to enable wide-area service discovery.";
    };

    reflector = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc "Reflect incoming mDNS requests to all allowed network interfaces.";
    };

    extraServiceFiles = mkOption {
      type = with types; attrsOf (either str path);
      default = { };
      example = literalExpression ''
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
      description = lib.mdDoc ''
        Specify custom service definitions which are placed in the avahi service directory.
        See the {manpage}`avahi.service(5)` manpage for detailed information.
      '';
    };

    publish = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Whether to allow publishing in general.";
      };

      userServices = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Whether to publish user services. Will set `addresses=true`.";
      };

      addresses = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Whether to register mDNS address records for all local IP addresses.";
      };

      hinfo = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to register a mDNS HINFO record which contains information about the
          local operating system and CPU.
        '';
      };

      workstation = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to register a service of type "_workstation._tcp" on the local LAN.
        '';
      };

      domain = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Whether to announce the locally used domain name for browsing by other hosts.";
      };
    };

    nssmdns = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable the mDNS NSS (Name Service Switch) plug-in.
        Enabling it allows applications to resolve names in the `.local`
        domain by transparently querying the Avahi daemon.
      '';
    };

    cacheEntriesMax = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = lib.mdDoc ''
        Number of resource records to be cached per interface. Use 0 to
        disable caching. Avahi daemon defaults to 4096 if not set.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = lib.mdDoc ''
        Extra config to append to avahi-daemon.conf.
      '';
    };
  };

  config = mkIf cfg.enable {
    users.users.avahi = {
      description = "avahi-daemon privilege separation user";
      home = "/var/empty";
      group = "avahi";
      isSystemUser = true;
    };

    users.groups.avahi = { };

    system.nssModules = optional cfg.nssmdns pkgs.nssmdns;
    system.nssDatabases.hosts = optionals cfg.nssmdns (mkMerge [
      (mkBefore [ "mdns_minimal [NOTFOUND=return]" ]) # before resolve
      (mkAfter [ "mdns" ]) # after dns
    ]);

    environment.systemPackages = [ pkgs.avahi ];

    environment.etc = (mapAttrs'
      (n: v: nameValuePair
        "avahi/services/${n}.service"
        { ${if types.path.check v then "source" else "text"} = v; }
      )
      cfg.extraServiceFiles);

    systemd.sockets.avahi-daemon = {
      description = "Avahi mDNS/DNS-SD Stack Activation Socket";
      listenStreams = [ "/run/avahi-daemon/socket" ];
      wantedBy = [ "sockets.target" ];
    };

    systemd.tmpfiles.rules = [ "d /run/avahi-daemon - avahi avahi -" ];

    systemd.services.avahi-daemon = {
      description = "Avahi mDNS/DNS-SD Stack";
      wantedBy = [ "multi-user.target" ];
      requires = [ "avahi-daemon.socket" ];

      # Make NSS modules visible so that `avahi_nss_support ()' can
      # return a sensible value.
      environment.LD_LIBRARY_PATH = config.system.nssModules.path;

      path = [ pkgs.coreutils pkgs.avahi ];

      serviceConfig = {
        NotifyAccess = "main";
        BusName = "org.freedesktop.Avahi";
        Type = "dbus";
        ExecStart = "${pkgs.avahi}/sbin/avahi-daemon --syslog -f ${avahiDaemonConf}";
        ConfigurationDirectory = "avahi/services";
      };
    };

    services.dbus.enable = true;
    services.dbus.packages = [ pkgs.avahi ];

    networking.firewall.allowedUDPPorts = mkIf cfg.openFirewall [ 5353 ];
  };
}
