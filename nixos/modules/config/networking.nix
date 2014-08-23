# /etc files related to networking, such as /etc/services.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.networking;

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
            '' + optionalString config.services.bind.enable ''
              # This hosts runs a full-blown DNS resolver.
              name_servers='127.0.0.1'
            '';
      };

    # The ‘ip-up’ target is started when we have IP connectivity.  So
    # services that depend on IP connectivity (like ntpd) should be
    # pulled in by this target.
    systemd.targets.ip-up.description = "Services Requiring IP Connectivity";

  };

}
