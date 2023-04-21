{ config, lib, pkgs, ... }:

with lib;

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
    ${optionalString (cfg.hostsAllowReg != []) "hosts_allow_reg = ${concatStringsSep "," cfg.hostsAllowReg}"}
    ${optionalString (cfg.hostsAllowSip != []) "hosts_allow_sip = ${concatStringsSep "," cfg.hostsAllowSip}"}
    ${optionalString (cfg.hostsDenySip != []) "hosts_deny_sip  = ${concatStringsSep "," cfg.hostsDenySip}"}
    ${optionalString (cfg.passwordFile != "") "proxy_auth_pwfile = ${cfg.passwordFile}"}
    ${cfg.extraConfig}
  '';

  confFile = builtins.toFile "siproxd.conf" conf;

in
{
  ##### interface

  options = {

    services.siproxd = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable the Siproxd SIP
          proxy/masquerading daemon.
        '';
      };

      ifInbound = mkOption {
        type = types.str;
        example = "eth0";
        description = lib.mdDoc "Local network interface";
      };

      ifOutbound = mkOption {
        type = types.str;
        example = "ppp0";
        description = lib.mdDoc "Public network interface";
      };

      hostsAllowReg = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "192.168.1.0/24" "192.168.2.0/24" ];
        description = lib.mdDoc ''
          Acess control list for incoming SIP registrations.
        '';
      };

      hostsAllowSip = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "123.45.0.0/16" "123.46.0.0/16" ];
        description = lib.mdDoc ''
          Acess control list for incoming SIP traffic.
        '';
      };

      hostsDenySip = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "10.0.0.0/8" "11.0.0.0/8" ];
        description = lib.mdDoc ''
          Acess control list for denying incoming
          SIP registrations and traffic.
        '';
      };

      sipListenPort = mkOption {
        type = types.int;
        default = 5060;
        description = lib.mdDoc ''
          Port to listen for incoming SIP messages.
        '';
      };

      rtpPortLow = mkOption {
        type = types.int;
        default = 7070;
        description = lib.mdDoc ''
         Bottom of UDP port range for incoming and outgoing RTP traffic
        '';
      };

      rtpPortHigh = mkOption {
        type = types.int;
        default = 7089;
        description = lib.mdDoc ''
         Top of UDP port range for incoming and outgoing RTP traffic
        '';
      };

      rtpTimeout = mkOption {
        type = types.int;
        default = 300;
        description = lib.mdDoc ''
          Timeout for an RTP stream. If for the specified
          number of seconds no data is relayed on an active
          stream, it is considered dead and will be killed.
        '';
      };

      rtpDscp = mkOption {
        type = types.int;
        default = 46;
        description = lib.mdDoc ''
          DSCP (differentiated services) value to be assigned
          to RTP packets. Allows QOS aware routers to handle
          different types traffic with different priorities.
        '';
      };

      sipDscp = mkOption {
        type = types.int;
        default = 0;
        description = lib.mdDoc ''
          DSCP (differentiated services) value to be assigned
          to SIP packets. Allows QOS aware routers to handle
          different types traffic with different priorities.
        '';
      };

      passwordFile = mkOption {
        type = types.str;
        default = "";
        description = lib.mdDoc ''
          Path to per-user password file.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc ''
          Extra configuration to add to siproxd configuration.
        '';
      };

    };

  };

  ##### implementation

  config = mkIf cfg.enable {

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
