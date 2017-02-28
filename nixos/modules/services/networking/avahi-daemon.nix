# Avahi daemon.
{ config, lib, utils, pkgs, ... }:

with lib;

let

  cfg = config.services.avahi;

  avahiDaemonConf = with cfg; pkgs.writeText "avahi-daemon.conf" ''
    [server]
    ${# Users can set `networking.hostName' to the empty string, when getting
      # a host name from DHCP.  In that case, let Avahi take whatever the
      # current host name is; setting `host-name' to the empty string in
      # `avahi-daemon.conf' would be invalid.
      if hostName != ""
      then "host-name=${hostName}"
      else ""}
    browse-domains=${concatStringsSep ", " browseDomains}
    use-ipv4=${if ipv4 then "yes" else "no"}
    use-ipv6=${if ipv6 then "yes" else "no"}
    ${optionalString (interfaces!=null) "allow-interfaces=${concatStringsSep "," interfaces}"}
    ${optionalString (domainName!=null) "domain-name=${domainName}"}
    allow-point-to-point=${if allowPointToPoint then "yes" else "no"}

    [wide-area]
    enable-wide-area=${if wideArea then "yes" else "no"}

    [publish]
    disable-publishing=${if publish.enable then "no" else "yes"}
    disable-user-service-publishing=${if publish.userServices then "no" else "yes"}
    publish-addresses=${if publish.userServices || publish.addresses then "yes" else "no"}
    publish-hinfo=${if publish.hinfo then "yes" else "no"}
    publish-workstation=${if publish.workstation then "yes" else "no"}
    publish-domain=${if publish.domain then "yes" else "no"}
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

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.avahi.hostName = mkDefault config.networking.hostName;

    users.extraUsers = singleton
      { name = "avahi";
        uid = config.ids.uids.avahi;
        description = "`avahi-daemon' privilege separation user";
        home = "/var/empty";
      };

    users.extraGroups = singleton
      { name = "avahi";
        gid = config.ids.gids.avahi;
      };

    system.nssModules = optional cfg.nssmdns pkgs.nssmdns;

    environment.systemPackages = [ pkgs.avahi ];

    systemd.sockets.avahi-daemon =
      { description = "Avahi mDNS/DNS-SD Stack Activation Socket";
        listenStreams = [ "/var/run/avahi-daemon/socket" ];
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

        preStart = "mkdir -p /var/run/avahi-daemon";

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
