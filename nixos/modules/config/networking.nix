# /etc files related to networking, such as /etc/services.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.networking;
  dnsmasqResolve = config.services.dnsmasq.enable &&
                   config.services.dnsmasq.resolveLocalQueries;
  hasLocalResolver = config.services.bind.enable || dnsmasqResolve;

in

{

  options = {

    networking.extraHosts = lib.mkOption {
      type = types.lines;
      default = "";
      example = "192.168.0.1 lanlocalhost";
      description = ''
        Additional entries to be appended to <filename>/etc/hosts</filename>.
      '';
    };

    networking.dnsSingleRequest = lib.mkOption {
      type = types.bool;
      default = false;
      description = ''
        Recent versions of glibc will issue both ipv4 (A) and ipv6 (AAAA)
        address queries at the same time, from the same port. Sometimes upstream
        routers will systemically drop the ipv4 queries. The symptom of this problem is
        that 'getent hosts example.com' only returns ipv6 (or perhaps only ipv4) addresses. The
        workaround for this is to specify the option 'single-request' in
        /etc/resolv.conf. This option enables that.
      '';
    };

  };

  config = {

    environment.etc =
      { # /etc/services: TCP/UDP port assignments.
        "services".source = pkgs.iana_etc + "/etc/services";

        # /etc/protocols: IP protocol numbers.
        "protocols".source  = pkgs.iana_etc + "/etc/protocols";

        # /etc/rpc: RPC program numbers.
        "rpc".source = pkgs.glibc + "/etc/rpc";

        # /etc/hosts: Hostname-to-IP mappings.
        "hosts".text =
          ''
            127.0.0.1 localhost
            ${optionalString cfg.enableIPv6 ''
              ::1 localhost
            ''}
            ${cfg.extraHosts}
          '';

        # /etc/resolvconf.conf: Configuration for openresolv.
        "resolvconf.conf".text =
            ''
              # This is the default, but we must set it here to prevent
              # a collision with an apparently unrelated environment
              # variable with the same name exported by dhcpcd.
              interface_order='lo lo[0-9]*'
            '' + optionalString config.services.nscd.enable ''
              # Invalidate the nscd cache whenever resolv.conf is
              # regenerated.
              libc_restart='${pkgs.systemd}/bin/systemctl try-restart --no-block nscd.service'
            '' + optionalString cfg.dnsSingleRequest ''
              # only send one DNS request at a time
              resolv_conf_options='single-request'
            '' + optionalString hasLocalResolver ''
              # This hosts runs a full-blown DNS resolver.
              name_servers='127.0.0.1'
            '' + optionalString dnsmasqResolve ''
              dnsmasq_conf=/etc/dnsmasq-conf.conf
              dnsmasq_resolv=/etc/dnsmasq-resolv.conf
            '';

      } // (optionalAttrs config.services.resolved.enable (
        if dnsmasqResolve then {
          "dnsmasq-resolv.conf".source = "/run/systemd/resolve/resolv.conf";
        } else {
          "resolv.conf".source = "/run/systemd/resolve/resolv.conf";
        }
      ));

    # The ‘ip-up’ target is started when we have IP connectivity.  So
    # services that depend on IP connectivity (like ntpd) should be
    # pulled in by this target.
    systemd.targets.ip-up.description = "Services Requiring IP Connectivity";

    # This is needed when /etc/resolv.conf is being overriden by networkd
    # and other configurations. If the file is destroyed by an environment
    # activation then it must be rebuilt so that applications which interface
    # with /etc/resolv.conf directly don't break.
    system.activationScripts.resolvconf = stringAfter [ "etc" "tmpfs" "var" ]
      ''
        # Systemd resolved controls its own resolv.conf
        rm -f /run/resolvconf/interfaces/systemd
        ${optionalString config.services.resolved.enable ''
          rm -rf /run/resolvconf/interfaces
          mkdir -p /run/resolvconf/interfaces
          ln -s /run/systemd/resolve/resolv.conf /run/resolvconf/interfaces/systemd
        ''}

        # Make sure resolv.conf is up to date
        ${pkgs.openresolv}/bin/resolvconf -u
      '';

  };

}
