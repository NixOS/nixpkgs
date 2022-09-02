{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.services.ocserv;

in

{
  options.services.ocserv = {
    enable = mkEnableOption (lib.mdDoc "ocserv");

    config = mkOption {
      type = types.lines;

      description = lib.mdDoc ''
        Configuration content to start an OCServ server.

        For a full configuration reference,please refer to the online documentation
        (https://ocserv.gitlab.io/www/manual.html), the openconnect
        recipes (https://github.com/openconnect/recipes) or `man ocserv`.
      '';

      example = ''
        # configuration examples from $out/doc without explanatory comments.
        # for a full reference please look at the installed man pages.
        auth = "plain[passwd=./sample.passwd]"
        tcp-port = 443
        udp-port = 443
        run-as-user = nobody
        run-as-group = nogroup
        socket-file = /run/ocserv-socket
        server-cert = certs/server-cert.pem
        server-key = certs/server-key.pem
        keepalive = 32400
        dpd = 90
        mobile-dpd = 1800
        switch-to-tcp-timeout = 25
        try-mtu-discovery = false
        cert-user-oid = 0.9.2342.19200300.100.1.1
        tls-priorities = "NORMAL:%SERVER_PRECEDENCE:%COMPAT:-VERS-SSL3.0"
        auth-timeout = 240
        min-reauth-time = 300
        max-ban-score = 80
        ban-reset-time = 1200
        cookie-timeout = 300
        deny-roaming = false
        rekey-time = 172800
        rekey-method = ssl
        use-occtl = true
        pid-file = /run/ocserv.pid
        device = vpns
        predictable-ips = true
        default-domain = example.com
        ipv4-network = 192.168.1.0
        ipv4-netmask = 255.255.255.0
        dns = 192.168.1.2
        ping-leases = false
        route = 10.10.10.0/255.255.255.0
        route = 192.168.0.0/255.255.0.0
        no-route = 192.168.5.0/255.255.255.0
        cisco-client-compat = true
        dtls-legacy = true

        [vhost:www.example.com]
        auth = "certificate"
        ca-cert = certs/ca.pem
        server-cert = certs/server-cert-secp521r1.pem
        server-key = cersts/certs/server-key-secp521r1.pem
        ipv4-network = 192.168.2.0
        ipv4-netmask = 255.255.255.0
        cert-user-oid = 0.9.2342.19200300.100.1.1
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.ocserv ];
    environment.etc."ocserv/ocserv.conf".text = cfg.config;

    security.pam.services.ocserv = {};

    systemd.services.ocserv = {
      description = "OpenConnect SSL VPN server";
      documentation = [ "man:ocserv(8)" ];
      after = [ "dbus.service" "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        PrivateTmp = true;
        PIDFile = "/run/ocserv.pid";
        ExecStart = "${pkgs.ocserv}/bin/ocserv --foreground --pid-file /run/ocesrv.pid --config /etc/ocserv/ocserv.conf";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };
    };
  };
}
