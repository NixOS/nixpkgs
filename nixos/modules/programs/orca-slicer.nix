{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.orca-slicer;
in
{
  options = {
    programs.orca-slicer = {
      enable = lib.mkEnableOption "G-code generator for 3D printers (Bambu, Prusa, Voron, VzBot, RatRig, Creality, etc.)";
      package = lib.mkPackageOption pkgs "orca-slicer" { };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to enable multicast ports in the firewall to discover printers on the LAN
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    networking.firewall = lib.mkIf cfg.openFirewall {
      extraCommands = ''
        iptables -I INPUT -m pkttype --pkt-type multicast -j ACCEPT
        iptables -A INPUT -m pkttype --pkt-type multicast -j ACCEPT
        iptables -I INPUT -p udp -m udp --match multiport --dports 1990,2021 -j ACCEPT
      '';
    };
  };
}
