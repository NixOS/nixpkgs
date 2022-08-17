{ config, pkgs, lib, ... }:

with lib;

{
  options = {
    services.pptpd = {
      enable = mkEnableOption "pptpd, the Point-to-Point Tunneling Protocol daemon";

      serverIp = mkOption {
        type        = types.str;
        description = lib.mdDoc "The server-side IP address.";
        default     = "10.124.124.1";
      };

      clientIpRange = mkOption {
        type        = types.str;
        description = lib.mdDoc "The range from which client IPs are drawn.";
        default     = "10.124.124.2-11";
      };

      maxClients = mkOption {
        type        = types.int;
        description = lib.mdDoc "The maximum number of simultaneous connections.";
        default     = 10;
      };

      extraPptpdOptions = mkOption {
        type        = types.lines;
        description = lib.mdDoc "Adds extra lines to the pptpd configuration file.";
        default     = "";
      };

      extraPppdOptions = mkOption {
        type        = types.lines;
        description = lib.mdDoc "Adds extra lines to the pppd options file.";
        default     = "";
        example     = ''
          ms-dns 8.8.8.8
          ms-dns 8.8.4.4
        '';
      };
    };
  };

  config = mkIf config.services.pptpd.enable {
    systemd.services.pptpd = let
      cfg = config.services.pptpd;

      pptpd-conf = pkgs.writeText "pptpd.conf" ''
        # Inspired from pptpd-1.4.0/samples/pptpd.conf
        ppp ${ppp-pptpd-wrapped}/bin/pppd
        option ${pppd-options}
        pidfile /run/pptpd.pid
        localip ${cfg.serverIp}
        remoteip ${cfg.clientIpRange}
        connections ${toString cfg.maxClients} # (Will get harmless warning if inconsistent with IP range)

        # Extra
        ${cfg.extraPptpdOptions}
      '';

      pppd-options = pkgs.writeText "ppp-options-pptpd.conf" ''
        # From: cat pptpd-1.4.0/samples/options.pptpd | grep -v ^# | grep -v ^$
        name pptpd
        refuse-pap
        refuse-chap
        refuse-mschap
        require-mschap-v2
        require-mppe-128
        proxyarp
        lock
        nobsdcomp
        novj
        novjccomp
        nologfd

        # Extra:
        ${cfg.extraPppdOptions}
      '';

      ppp-pptpd-wrapped = pkgs.stdenv.mkDerivation {
        name         = "ppp-pptpd-wrapped";
        phases       = [ "installPhase" ];
        buildInputs  = with pkgs; [ makeWrapper ];
        installPhase = ''
          mkdir -p $out/bin
          makeWrapper ${pkgs.ppp}/bin/pppd $out/bin/pppd \
            --set LD_PRELOAD    "${pkgs.libredirect}/lib/libredirect.so" \
            --set NIX_REDIRECTS "/etc/ppp=/etc/ppp-pptpd"
        '';
      };
    in {
      description = "pptpd server";

      requires = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        mkdir -p -m 700 /etc/ppp-pptpd

        secrets="/etc/ppp-pptpd/chap-secrets"

        [ -f "$secrets" ] || cat > "$secrets" << EOF
        # From: pptpd-1.4.0/samples/chap-secrets
        # Secrets for authentication using CHAP
        # client	server	secret		IP addresses
        #username	pptpd	password	*
        EOF

        chown root:root "$secrets"
        chmod 600 "$secrets"
      '';

      serviceConfig = {
        ExecStart = "${pkgs.pptpd}/bin/pptpd --conf ${pptpd-conf}";
        KillMode  = "process";
        Restart   = "on-success";
        Type      = "forking";
        PIDFile   = "/run/pptpd.pid";
      };
    };
  };
}
