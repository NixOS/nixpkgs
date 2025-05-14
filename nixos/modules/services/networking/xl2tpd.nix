{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

{
  options = {
    services.xl2tpd = {
      enable = mkEnableOption "xl2tpd, the Layer 2 Tunnelling Protocol Daemon";

      serverIp = mkOption {
        type = types.str;
        description = "The server-side IP address.";
        default = "10.125.125.1";
      };

      clientIpRange = mkOption {
        type = types.str;
        description = "The range from which client IPs are drawn.";
        default = "10.125.125.2-11";
      };

      extraXl2tpOptions = mkOption {
        type = types.lines;
        description = "Adds extra lines to the xl2tpd configuration file.";
        default = "";
      };

      extraPppdOptions = mkOption {
        type = types.lines;
        description = "Adds extra lines to the pppd options file.";
        default = "";
        example = ''
          ms-dns 8.8.8.8
          ms-dns 8.8.4.4
        '';
      };
    };
  };

  config = mkIf config.services.xl2tpd.enable {
    systemd.services.xl2tpd =
      let
        cfg = config.services.xl2tpd;

        # Config files from https://help.ubuntu.com/community/L2TPServer
        xl2tpd-conf = pkgs.writeText "xl2tpd.conf" ''
          [global]
          ipsec saref = no

          [lns default]
          local ip = ${cfg.serverIp}
          ip range = ${cfg.clientIpRange}
          pppoptfile = ${pppd-options}
          length bit = yes

          ; Extra
          ${cfg.extraXl2tpOptions}
        '';

        pppd-options = pkgs.writeText "ppp-options-xl2tpd.conf" ''
          refuse-pap
          refuse-chap
          refuse-mschap
          require-mschap-v2
          # require-mppe-128
          asyncmap 0
          auth
          crtscts
          idle 1800
          mtu 1200
          mru 1200
          lock
          hide-password
          local
          # debug
          name xl2tpd
          # proxyarp
          lcp-echo-interval 30
          lcp-echo-failure 4

          # Extra:
          ${cfg.extraPppdOptions}
        '';

        xl2tpd-ppp-wrapped = pkgs.stdenv.mkDerivation {
          name = "xl2tpd-ppp-wrapped";
          phases = [ "installPhase" ];
          nativeBuildInputs = with pkgs; [ makeWrapper ];
          installPhase = ''
            mkdir -p $out/bin

            makeWrapper ${pkgs.ppp}/sbin/pppd $out/bin/pppd \
              --set LD_PRELOAD    "${pkgs.libredirect}/lib/libredirect.so" \
              --set NIX_REDIRECTS "/etc/ppp=/etc/xl2tpd/ppp"

            makeWrapper ${pkgs.xl2tpd}/bin/xl2tpd $out/bin/xl2tpd \
              --set LD_PRELOAD    "${pkgs.libredirect}/lib/libredirect.so" \
              --set NIX_REDIRECTS "${pkgs.ppp}/sbin/pppd=$out/bin/pppd"
          '';
        };
      in
      {
        description = "xl2tpd server";

        requires = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];

        preStart = ''
          install -m 700 -d /etc/xl2tpd/ppp

          [ -f /etc/xl2tpd/ppp/chap-secrets ] || install -m 600 -o root -g root /dev/stdin /etc/xl2tpd/ppp/chap-secrets <<EOF
          # Secrets for authentication using CHAP
          # client	server	secret		IP addresses
          #username	xl2tpd	password	*
          EOF

          # The documentation says this file should be present but doesn't explain why and things work even if not there:
          [ -f /etc/xl2tpd/l2tp-secrets ] || install -m 600 -o root -g root <(echo -n "* * "; ${pkgs.apg}/bin/apg -n 1 -m 32 -x 32 -a 1 -M LCN) /etc/xl2tpd/l2tp-secrets

          install -m 701 -o root -g root -d /run/xl2tpd
        '';

        serviceConfig = {
          ExecStart = "${xl2tpd-ppp-wrapped}/bin/xl2tpd -D -c ${xl2tpd-conf} -s /etc/xl2tpd/l2tp-secrets -p /run/xl2tpd/pid -C /run/xl2tpd/control";
          KillMode = "process";
          Restart = "on-success";
          Type = "simple";
          PIDFile = "/run/xl2tpd/pid";
        };
      };
  };
}
