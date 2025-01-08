{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.virtualisation.vmware.guest;
  xf86inputvmmouse = pkgs.xorg.xf86inputvmmouse;
in
{
  imports = [
    (lib.mkRenamedOptionModule [ "services" "vmwareGuest" ] [ "virtualisation" "vmware" "guest" ])
  ];

  meta = {
    maintainers = [ lib.maintainers.kjeremy ];
  };

  options.virtualisation.vmware.guest = {
    enable = lib.mkEnableOption "VMWare Guest Support";
    headless = lib.mkOption {
      type = lib.types.bool;
      default = !config.services.xserver.enable;
      defaultText = lib.literalExpression "!config.services.xserver.enable";
      description = "Whether to disable X11-related features.";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = if cfg.headless then pkgs.open-vm-tools-headless else pkgs.open-vm-tools;
      defaultText = lib.literalExpression "if config.virtualisation.vmware.headless then pkgs.open-vm-tools-headless else pkgs.open-vm-tools;";
      example = lib.literalExpression "pkgs.open-vm-tools";
      description = "Package providing open-vm-tools.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = pkgs.stdenv.hostPlatform.isx86 || pkgs.stdenv.hostPlatform.isAarch64;
        message = "VMWare guest is not currently supported on ${pkgs.stdenv.hostPlatform.system}";
      }
    ];

    boot.initrd.availableKernelModules = [ "mptspi" ];
    boot.initrd.kernelModules = lib.optionals pkgs.stdenv.hostPlatform.isx86 [ "vmw_pvscsi" ];

    environment.systemPackages = [ cfg.package ];

    systemd.services.vmware = {
      description = "VMWare Guest Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "display-manager.service" ];
      unitConfig.ConditionVirtualization = "vmware";
      serviceConfig.ExecStart = lib.getExe' cfg.package "vmtoolsd";
    };

    # Mount the vmblock for drag-and-drop and copy-and-paste.
    systemd.mounts = lib.mkIf (!cfg.headless) [
      {
        description = "VMware vmblock fuse mount";
        documentation = [
          "https://github.com/vmware/open-vm-tools/blob/master/open-vm-tools/vmblock-fuse/design.txt"
        ];
        unitConfig.ConditionVirtualization = "vmware";
        what = lib.getExe' cfg.package "vmware-vmblock-fuse";
        where = "/run/vmblock-fuse";
        type = "fuse";
        options = "subtype=vmware-vmblock,default_permissions,allow_other";
        wantedBy = [ "multi-user.target" ];
      }
    ];

    security.wrappers.vmware-user-suid-wrapper = lib.mkIf (!cfg.headless) {
      setuid = true;
      owner = "root";
      group = "root";
      source = lib.getExe' cfg.package "vmware-user-suid-wrapper";
    };

    environment.etc.vmware-tools.source = "${cfg.package}/etc/vmware-tools/*";

    services.xserver = lib.mkIf (!cfg.headless) {
      modules = lib.optionals pkgs.stdenv.hostPlatform.isx86 [ xf86inputvmmouse ];

      config = lib.optionalString (pkgs.stdenv.hostPlatform.isx86) ''
        Section "InputClass"
          Identifier "VMMouse"
          MatchDevicePath "/dev/input/event*"
          MatchProduct "ImPS/2 Generic Wheel Mouse"
          Driver "vmmouse"
        EndSection
      '';

      displayManager.sessionCommands = ''
        ${lib.getExe' cfg.package "vmware-user-suid-wrapper"}
      '';
    };

    services.udev.packages = [ cfg.package ];
  };
}
