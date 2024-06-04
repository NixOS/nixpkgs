# GNU Virtual Private Ethernet

{config, pkgs, lib, ...}:

let
  inherit (lib) mkOption mkIf types;

  cfg = config.services.gvpe;

  finalConfig = if cfg.configFile != null then
    cfg.configFile
  else if cfg.configText != null then
    pkgs.writeTextFile {
      name = "gvpe.conf";
      text = cfg.configText;
    }
  else
    throw "You must either specify contents of the config file or the config file itself for GVPE";

  ifupScript = if cfg.ipAddress == null || cfg.subnet == null then
     throw "Specify IP address and subnet (with mask) for GVPE"
   else if cfg.nodename == null then
     throw "You must set node name for GVPE"
   else
   (pkgs.writeTextFile {
    name = "gvpe-if-up";
    text = ''
      #! /bin/sh

      export PATH=$PATH:${pkgs.iproute2}/sbin

      ip link set dev $IFNAME up
      ip address add ${cfg.ipAddress} dev $IFNAME
      ip route add ${cfg.subnet} dev $IFNAME

      ${cfg.customIFSetup}
    '';
    executable = true;
  });
in

{
  options = {
    services.gvpe = {
      enable = lib.mkEnableOption "gvpe";

      nodename = mkOption {
        default = null;
        type = types.nullOr types.str;
        description = ''
          GVPE node name
        '';
      };
      configText = mkOption {
        default = null;
        type = types.nullOr types.lines;
        example = ''
          tcp-port = 655
          udp-port = 655
          mtu = 1480
          ifname = vpn0

          node = alpha
          hostname = alpha.example.org
          connect = always
          enable-udp = true
          enable-tcp = true
          on alpha if-up = if-up-0
          on alpha pid-file = /var/gvpe/gvpe.pid
        '';
        description = ''
          GVPE config contents
        '';
      };
      configFile = mkOption {
        default = null;
        type = types.nullOr types.path;
        example = "/root/my-gvpe-conf";
        description = ''
          GVPE config file, if already present
        '';
      };
      ipAddress = mkOption {
        default = null;
        type = types.nullOr types.str;
        description = ''
          IP address to assign to GVPE interface
        '';
      };
      subnet = mkOption {
        default = null;
        type = types.nullOr types.str;
        example = "10.0.0.0/8";
        description = ''
          IP subnet assigned to GVPE network
        '';
      };
      customIFSetup = mkOption {
        default = "";
        type = types.lines;
        description = ''
          Additional commands to apply in ifup script
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    systemd.services.gvpe = {
      description = "GNU Virtual Private Ethernet node";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        mkdir -p /var/gvpe
        mkdir -p /var/gvpe/pubkey
        chown root /var/gvpe
        chmod 700 /var/gvpe
        cp ${finalConfig} /var/gvpe/gvpe.conf
        cp ${ifupScript} /var/gvpe/if-up
      '';

      script = "${pkgs.gvpe}/sbin/gvpe -c /var/gvpe -D ${cfg.nodename} "
        + " ${cfg.nodename}.pid-file=/var/gvpe/gvpe.pid"
        + " ${cfg.nodename}.if-up=if-up"
        + " &> /var/log/gvpe";

      serviceConfig.Restart = "always";
    };
  };
}
