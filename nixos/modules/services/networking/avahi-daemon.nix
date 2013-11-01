# Avahi daemon.
{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.avahi;

  inherit (pkgs) avahi;

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

    [wide-area]
    enable-wide-area=${if wideArea then "yes" else "no"}

    [publish]
    disable-publishing=${if publishing then "no" else "yes"}
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
        description = ''Host name advertised on the LAN.'';
      };

      browseDomains = mkOption {
        default = [ "0pointer.de" "zeroconf.org" ];
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

      wideArea = mkOption {
        default = true;
        description = ''Whether to enable wide-area service discovery.'';
      };

      publishing = mkOption {
        default = true;
        description = ''Whether to allow publishing.'';
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

    environment.systemPackages = [ avahi ];

    jobs.avahi_daemon =
      { name = "avahi-daemon";

        startOn = "ip-up";

        script =
          ''
            export PATH="${avahi}/bin:${avahi}/sbin:$PATH"

            # Make NSS modules visible so that `avahi_nss_support ()' can
            # return a sensible value.
            export LD_LIBRARY_PATH="${config.system.nssModules.path}"

            mkdir -p /var/run/avahi-daemon

            exec ${avahi}/sbin/avahi-daemon --syslog -f "${avahiDaemonConf}"
          '';
      };

    services.dbus.enable = true;
    services.dbus.packages = [avahi];

  };

}
