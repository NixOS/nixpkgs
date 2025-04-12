{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    getExe'
    literalExpression
    mkEnableOption
    mkIf
    mkOption
    mkRenamedOptionModule
    optionals
    optionalString
    types
    ;
  cfg = config.virtualisation.vmware.guest;
  xf86inputvmmouse = pkgs.xorg.xf86inputvmmouse;
in
{
  imports = [
    (mkRenamedOptionModule [ "services" "vmwareGuest" ] [ "virtualisation" "vmware" "guest" ])
  ];

  meta = {
    maintainers = [ lib.maintainers.kjeremy ];
  };

  options.virtualisation.vmware.guest = {
    enable = mkEnableOption "VMWare Guest Support";
    headless = mkOption {
      type = types.bool;
      default = !config.services.xserver.enable;
      defaultText = literalExpression "!config.services.xserver.enable";
      description = "Whether to disable X11-related features.";
    };

    package = mkOption {
      type = types.package;
      default = if cfg.headless then pkgs.open-vm-tools-headless else pkgs.open-vm-tools;
      defaultText = literalExpression "if config.virtualisation.vmware.headless then pkgs.open-vm-tools-headless else pkgs.open-vm-tools;";
      example = literalExpression "pkgs.open-vm-tools";
      description = "Package providing open-vm-tools.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = pkgs.stdenv.hostPlatform.isx86 || pkgs.stdenv.hostPlatform.isAarch64;
        message = "VMWare guest is not currently supported on ${pkgs.stdenv.hostPlatform.system}";
      }
    ];

    boot.initrd.availableKernelModules = [ "mptspi" ];
    boot.initrd.kernelModules = optionals pkgs.stdenv.hostPlatform.isx86 [ "vmw_pvscsi" ];

    environment.systemPackages = [ cfg.package ];

    systemd.services.vmware = {
      description = "VMWare Guest Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "display-manager.service" ];
      unitConfig.ConditionVirtualization = "vmware";
      serviceConfig.ExecStart = getExe' cfg.package "vmtoolsd";
    };

    # Mount the vmblock for drag-and-drop and copy-and-paste.
    systemd.mounts = mkIf (!cfg.headless) [
      {
        description = "VMware vmblock fuse mount";
        documentation = [
          "https://github.com/vmware/open-vm-tools/blob/master/open-vm-tools/vmblock-fuse/design.txt"
        ];
        unitConfig.ConditionVirtualization = "vmware";
        what = getExe' cfg.package "vmware-vmblock-fuse";
        where = "/run/vmblock-fuse";
        type = "fuse";
        options = "subtype=vmware-vmblock,default_permissions,allow_other";
        wantedBy = [ "multi-user.target" ];
      }
    ];

    security.wrappers.vmware-user-suid-wrapper = mkIf (!cfg.headless) {
      setuid = true;
      owner = "root";
      group = "root";
      source = getExe' cfg.package "vmware-user-suid-wrapper";
    };

    environment.etc.vmware-tools.source = "${cfg.package}/etc/vmware-tools/*";

    services.xserver = mkIf (!cfg.headless) {
      modules = optionals pkgs.stdenv.hostPlatform.isx86 [ xf86inputvmmouse ];

      config = optionalString (pkgs.stdenv.hostPlatform.isx86) ''
        Section "InputClass"
          Identifier "VMMouse"
          MatchDevicePath "/dev/input/event*"
          MatchProduct "ImPS/2 Generic Wheel Mouse"
          Driver "vmmouse"
        EndSection
      '';

      displayManager.sessionCommands = ''
        ${getExe' cfg.package "vmware-user-suid-wrapper"}
      '';
    };

    services.udev.packages = [ cfg.package ];
  };
}
