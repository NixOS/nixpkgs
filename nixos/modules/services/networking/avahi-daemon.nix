# Avahi daemon.
{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.avahi;

  yesNo = yes : if yes then "yes" else "no";

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
    ${optionalString (interfaces!=null) "allow-interfaces=${concatStringsSep "," interfaces}"}
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

  ###### interface

  options = {

    services.avahi = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to run the Avahi daemon, which allows Avahi clients
          to use Avahi's service discovery facilities and also allows
          the local machine to advertise its presence and services
          (through the mDNS responder implemented by `avahi-daemon').
        '';
      };

      hostName = mkOption {
        type = types.str;
        description = ''
          Host name advertised on the LAN. If not set, avahi will use the value
          of config.networking.hostName.
        '';
      };

      domainName = mkOption {
        type = types.str;
        default = "local";
        description = ''
          Domain name for all advertisements.
        '';
      };

      browseDomains = mkOption {
        default = [ ];
        example = [ "0pointer.de" "zeroconf.org" ];
        description = ''
          List of non-local DNS domains to be browsed.
        '';
      };

      ipv4 = mkOption {
        default = true;
        description = ''Whether to use IPv4'';
      };

      ipv6 = mkOption {
        default = false;
        description = ''Whether to use IPv6'';
      };

      interfaces = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
        description = ''
          List of network interfaces that should be used by the <command>avahi-daemon</command>.
          Other interfaces will be ignored. If <literal>null</literal> all local interfaces
          except loopback and point-to-point will be used.
        '';
      };

      allowPointToPoint = mkOption {
        default = false;
        description= ''
          Whether to use POINTTOPOINT interfaces. Might make mDNS unreliable due to usually large
          latencies with such links and opens a potential security hole by allowing mDNS access from Internet
          connections. Use with care and YMMV!
        '';
      };

      wideArea = mkOption {
        default = true;
        description = ''Whether to enable wide-area service discovery.'';
      };

      reflector = mkOption {
        default = false;
        description = ''Reflect incoming mDNS requests to all allowed network interfaces.'';
      };

      publish = {
        enable = mkOption {
          default = false;
          description = ''Whether to allow publishing in general.'';
        };

        userServices = mkOption {
          default = false;
          description = ''Whether to publish user services. Will set <literal>addresses=true</literal>.'';
        };

        addresses = mkOption {
          default = false;
          description = ''Whether to register mDNS address records for all local IP addresses.'';
        };

        hinfo = mkOption {
          default = false;
          description = ''
            Whether to register an mDNS HINFO record which contains information about the
            local operating system and CPU.
          '';
        };

        workstation = mkOption {
          default = false;
          description = ''Whether to register a service of type "_workstation._tcp" on the local LAN.'';
        };

        domain = mkOption {
          default = false;
          description = ''Whether to announce the locally used domain name for browsing by other hosts.'';
        };

      };

      nssmdns = mkOption {
        default = false;
        description = ''
          Whether to enable the mDNS NSS (Name Service Switch) plug-in.
          Enabling it allows applications to resolve names in the `.local'
          domain by transparently querying the Avahi daemon.
        '';
      };

      cacheEntriesMax = mkOption {
        default = null;
        type = types.nullOr types.int;
        description = ''
          Number of resource records to be cached per interface. Use 0 to
          disable caching. Avahi daemon defaults to 4096 if not set.
        '';
      };

      extraConfig = mkOption {
        default = "";
        type = types.lines;
        description = ''
          Extra config to append to avahi-daemon.conf.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.avahi.hostName = mkDefault config.networking.hostName;

    users.users = singleton
      { name = "avahi";
        uid = config.ids.uids.avahi;
        description = "`avahi-daemon' privilege separation user";
        home = "/var/empty";
      };

    users.groups = singleton
      { name = "avahi";
        gid = config.ids.gids.avahi;
      };

    system.nssModules = optional cfg.nssmdns pkgs.nssmdns;

    environment.systemPackages = [ pkgs.avahi ];

    systemd.sockets.avahi-daemon =
      { description = "Avahi mDNS/DNS-SD Stack Activation Socket";
        listenStreams = [ "/run/avahi-daemon/socket" ];
        wantedBy = [ "sockets.target" ];
      };

    systemd.services.avahi-daemon =
      { description = "Avahi mDNS/DNS-SD Stack";
        wantedBy = [ "multi-user.target" ];
        requires = [ "avahi-daemon.socket" ];

        serviceConfig."NotifyAccess" = "main";
        serviceConfig."BusName" = "org.freedesktop.Avahi";
        serviceConfig."Type" = "dbus";

        path = [ pkgs.coreutils pkgs.avahi ];

        preStart = "mkdir -p /run/avahi-daemon";

        script =
          ''
            # Make NSS modules visible so that `avahi_nss_support ()' can
            # return a sensible value.
            export LD_LIBRARY_PATH="${config.system.nssModules.path}"

            exec ${pkgs.avahi}/sbin/avahi-daemon --syslog -f "${avahiDaemonConf}"
          '';
      };

    services.dbus.enable = true;
    services.dbus.packages = [ pkgs.avahi ];

    # Enabling Avahi without exposing it in the firewall doesn't make
    # sense.
    networking.firewall.allowedUDPPorts = [ 5353 ];

  };

}
