{ config, pkgs, lib, ... }:

with pkgs;
with lib;

let
  cfg = config.services.jitsi.jitsi-videobridge;
in {
  options = {
    services.jitsi.jitsi-videobridge = {
      enable = mkEnableOption "jitsi-videobridge";

      user = mkOption {
        type = types.str;
        default = "jitsi";
        description = ''
          User name under which jitsi-videobridge shall be run.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "nogroup";
        description = ''
          Group under which jitsi-videobridge shall be run.
        '';
      };

      port = mkOption {
        type = types.int;
        default = 5275;
        description = ''
          Sets the port of the XMPP server.
        '';
      };

      minPort = mkOption {
        type = types.int;
        default = 10001;
        description = ''
          Sets the min port used for media.
        '';
      };

      maxPort = mkOption {
        type = types.int;
        default = 20000;
        description = ''
          Sets the max port used for media.
        '';
      };

      host = mkOption {
        type = types.nullOr types.str;
        default = if cfg.domain != null then cfg.domain else "localhost";
        description = ''
          Sets the hostname of the XMPP server.
        '';
      };

      secret = mkOption {
        type = types.str;
        description = ''
          Sets the shared secret used to authenticate to the XMPP server.
        '';
      };

      domain = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Sets the XMPP domain.
        '';
      };

      subdomain = mkOption {
        type = types.str;
        default = "jitsi-videobridge";
        description = ''
          Sets the sub-domain used to bind JVB XMPP component.
        '';
      };

      apis = mkOption {
        type = types.listOf (types.enum [ "xmpp" "rest" ]);
        apply = list: concatStringsSep "," list;
        default = ["xmpp"];
        description = ''
          Where APIS is a comma separated list of APIs to enable.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open port in firewall for incoming connections.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = if cfg.openFirewall then [ cfg.port 4443 ] else [];
    networking.firewall.allowedUDPPortRanges = if cfg.openFirewall then [{ from = cfg.minPort; to = cfg.maxPort; }] else [];

    users.extraUsers."${cfg.user}" = {
        home = "/home/${cfg.user}";
        description = "jitsi-videobridge user";
      };

    systemd.services.jitsi-videobridge = {
      description = "Jitsi Videobridge";
      path  = [ pkgs.jre ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      preStart = ''
        ${pkgs.coreutils}/bin/mkdir -p /home/${cfg.user}/.sip-communicator
        ${pkgs.coreutils}/bin/echo "org.jitsi.impl.neomedia.transform.srtp.SRTPCryptoContext.checkReplay=false" > /home/${cfg.user}/.sip-communicator/sip-communicator.properties
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = ''
          ${pkgs.jitsi-videobridge}/bin/jitsi-videobridge \
          --host=${cfg.host} \
          --port=${toString cfg.port} \
          --min-port=${toString cfg.minPort} \
          --max-port=${toString cfg.maxPort} \
          --secret=${cfg.secret} \
          --apis=${cfg.apis} \
          --subdomain=${cfg.subdomain} ${optionalString (cfg.domain != null) "--domain=${cfg.domain}"}
        '';
        ExecStopPost = "${pkgs.coreutils}/bin/rm -f /home/${cfg.user}/.sip-communicator/sip-communicator.properties";
        Restart  = "always";
        PrivateTmp = true;
        WorkingDirectory = "/tmp";
      };
    };
  };
}
