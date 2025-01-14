{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.siproxd;

  conf = ''
    daemonize = 0
    rtp_proxy_enable = 1
    user = siproxd
    if_inbound  = ${cfg.ifInbound}
    if_outbound = ${cfg.ifOutbound}
    sip_listen_port = ${toString cfg.sipListenPort}
    rtp_port_low    = ${toString cfg.rtpPortLow}
    rtp_port_high   = ${toString cfg.rtpPortHigh}
    rtp_dscp        = ${toString cfg.rtpDscp}
    sip_dscp        = ${toString cfg.sipDscp}
    ${lib.optionalString (
      cfg.hostsAllowReg != [ ]
    ) "hosts_allow_reg = ${lib.concatStringsSep "," cfg.hostsAllowReg}"}
    ${lib.optionalString (
      cfg.hostsAllowSip != [ ]
    ) "hosts_allow_sip = ${lib.concatStringsSep "," cfg.hostsAllowSip}"}
    ${lib.optionalString (
      cfg.hostsDenySip != [ ]
    ) "hosts_deny_sip  = ${lib.concatStringsSep "," cfg.hostsDenySip}"}
    ${lib.optionalString (cfg.passwordFile != "") "proxy_auth_pwfile = ${cfg.passwordFile}"}
    ${cfg.extraConfig}
  '';

  confFile = builtins.toFile "siproxd.conf" conf;

in
{
  ##### interface

  options = {

    services.siproxd = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable the Siproxd SIP
          proxy/masquerading daemon.
        '';
      };

      ifInbound = lib.mkOption {
        type = lib.types.str;
        example = "eth0";
        description = "Local network interface";
      };

      ifOutbound = lib.mkOption {
        type = lib.types.str;
        example = "ppp0";
        description = "Public network interface";
      };

      hostsAllowReg = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [
          "192.168.1.0/24"
          "192.168.2.0/24"
        ];
        description = ''
          Access control list for incoming SIP registrations.
        '';
      };

      hostsAllowSip = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [
          "123.45.0.0/16"
          "123.46.0.0/16"
        ];
        description = ''
          Access control list for incoming SIP traffic.
        '';
      };

      hostsDenySip = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [
          "10.0.0.0/8"
          "11.0.0.0/8"
        ];
        description = ''
          Access control list for denying incoming
          SIP registrations and traffic.
        '';
      };

      sipListenPort = lib.mkOption {
        type = lib.types.int;
        default = 5060;
        description = ''
          Port to listen for incoming SIP messages.
        '';
      };

      rtpPortLow = lib.mkOption {
        type = lib.types.int;
        default = 7070;
        description = ''
          Bottom of UDP port range for incoming and outgoing RTP traffic
        '';
      };

      rtpPortHigh = lib.mkOption {
        type = lib.types.int;
        default = 7089;
        description = ''
          Top of UDP port range for incoming and outgoing RTP traffic
        '';
      };

      rtpTimeout = lib.mkOption {
        type = lib.types.int;
        default = 300;
        description = ''
          Timeout for an RTP stream. If for the specified
          number of seconds no data is relayed on an active
          stream, it is considered dead and will be killed.
        '';
      };

      rtpDscp = lib.mkOption {
        type = lib.types.int;
        default = 46;
        description = ''
          DSCP (differentiated services) value to be assigned
          to RTP packets. Allows QOS aware routers to handle
          different types traffic with different priorities.
        '';
      };

      sipDscp = lib.mkOption {
        type = lib.types.int;
        default = 0;
        description = ''
          DSCP (differentiated services) value to be assigned
          to SIP packets. Allows QOS aware routers to handle
          different types traffic with different priorities.
        '';
      };

      passwordFile = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Path to per-user password file.
        '';
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Extra configuration to add to siproxd configuration.
        '';
      };

    };

  };

  ##### implementation

  config = lib.mkIf cfg.enable {

    users.users.siproxyd = {
      uid = config.ids.uids.siproxd;
    };

    systemd.services.siproxd = {
      description = "SIP proxy/masquerading daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.siproxd}/sbin/siproxd -c ${confFile}";
      };
    };

  };

}
