{ pkgs, config, lib, ... }:

let
  cfg = config.programs.gns3;
  inherit(lib) literalExpression maintainers mdDoc mkEnableOption mkIf mkOption types;
in
{
  options.programs.gns3 = {
    enable = mkEnableOption (mdDoc "GUI for NS-3");

    bridge.package = mkOption {
      type = types.package;
      default = pkgs.ubridge;
      description = mdDoc "Network bridge for UDP tunnels, ethernet, ...";
      defaultText = literalExpression "pkgs.ubridge";
      relatedPackages = [
        "ubridge"
      ];
    };

    ciscoRouterPackage = mkOption {
      type = types.package;
      default = pkgs.dynamips;
      description = mdDoc "Cisco router emulator to use";
      defaultText = literalExpression "pkgs.dynamips";
      relatedPackages = [
        "dynamips"
      ];
    };

    virtualisationPackage = mkOption {
      type = types.package;
      default = pkgs.qemu;
      description = mdDoc "Emulator or hypervisor to use";
      defaultText = literalExpression "pkgs.qemu";
      relatedPackages = [
        "qemu"
        "virtualbox"
      ];
    };

    package = mkOption {
      type = types.package;
      default = pkgs.gns3-gui;
      description = mdDoc "GNS3 GUI package to use";
      defaultText = literalExpression "pkgs.gns3-gui";
      relatedPackages = [
        "gns3-gui"
      ];
    };

    serverPackage = mkOption {
      type = types.package;
      default = pkgs.gns3-server;
      description = mdDoc "GNS3 server package to use";
      defaultText = literalExpression "pkgs.gns3-server";
      relatedPackages = [
        "gns3-server"
      ];
    };

    rdcPackage = mkOption {
      type = types.package;
      default = pkgs.turbovnc;
      description = mdDoc "Remote Desktop Client to connect to appliance";
      defaultText = literalExpression "pkgs.turbovnc";
      relatedPackages = [
        "libsForQt5.krdc"
        "gnome.vinagre"
        "remmina"
        "turbovnc"
        "virt-viewer"
      ];
    };

    terminalPackage = mkOption {
      type = types.package;
      default = pkgs.xterm;
      description = mdDoc "Which terminal emulator to use";
      defaultText = literalExpression "pkgs.xterm";
      relatedPackages = [
        "gnome.gnome-terminal"
        "kitty"
        "konsole"
        "mate.mate-terminal"
        "roxterm"
        "terminator"
        "xfce.xfce4-terminal"
        "xterm"
      ];
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [
      cfg.bridge.package
      cfg.ciscoRouterPackage
      cfg.package
      cfg.serverPackage
      cfg.rdcPackage
      cfg.terminalPackage
    ];

  };

  meta.maintainers = with maintainers; [ loveisgrief ];
}
