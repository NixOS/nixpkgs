{ config, pkgs, lib, ... }:

let
  cfg = config.virtualisation.vmware.host;
  wrapperDir = "/run/vmware/bin"; # Perfectly fits as /usr/local/bin
  parentWrapperDir = dirOf wrapperDir;
  vmwareWrappers = # Needed as hardcoded paths workaround
    let mkVmwareSymlink =
      program:
      ''
        ln -s "${config.security.wrapperDir}/${program}" $wrapperDir/${program}
      '';
    in
    [
      (mkVmwareSymlink "pkexec")
      (mkVmwareSymlink "mount")
      (mkVmwareSymlink "umount")
    ];
in
{
  options = with lib; {
    virtualisation.vmware.host = {
      enable = mkEnableOption (lib.mdDoc "VMware") // {
        description = lib.mdDoc ''
          This enables VMware host virtualisation for running VMs.

          ::: {.important}
          `vmware-vmx` will cause kcompactd0 due to
          `Transparent Hugepages` feature in kernel.
          Apply `[ "transparent_hugepage=never" ]` in
          option {option}`boot.kernelParams` to disable them.
          :::

          ::: {.note}
          If that didn't work disable `TRANSPARENT_HUGEPAGE`,
          `COMPACTION` configs and recompile kernel.
          :::
        '';
      };
      package = mkPackageOption pkgs "vmware-workstation" { };
      extraPackages = mkOption {
        type = with types; listOf package;
        default = with pkgs; [ ];
        description = lib.mdDoc "Extra packages to be used with VMware host.";
        example = "with pkgs; [ ntfs3g ]";
      };
      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc "Add extra config to /etc/vmware/config";
        example = ''
          # Allow unsupported device's OpenGL and Vulkan acceleration for guest vGPU
          mks.gl.allowUnsupportedDrivers = "TRUE"
          mks.vk.allowUnsupportedDevices = "TRUE"
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot.extraModulePackages = [ config.boot.kernelPackages.vmware ];
    boot.extraModprobeConfig = "alias char-major-10-229 fuse";
    boot.kernelModules = [ "vmw_pvscsi" "vmw_vmci" "vmmon" "vmnet" "fuse" ];

    environment.systemPackages = [ cfg.package ] ++ cfg.extraPackages;
    services.printing.drivers = [ cfg.package ];

    environment.etc."vmware/config".text = ''
      ${builtins.readFile "${cfg.package}/etc/vmware/config"}
      ${cfg.extraConfig}
    '';

    environment.etc."vmware/bootstrap".source = "${cfg.package}/etc/vmware/bootstrap";
    environment.etc."vmware/icu".source = "${cfg.package}/etc/vmware/icu";
    environment.etc."vmware-installer".source = "${cfg.package}/etc/vmware-installer";

    # SUID wrappers

    security.wrappers = {
      vmware-vmx = {
        setuid = true;
        owner = "root";
        group = "root";
        source = "${cfg.package}/lib/vmware/bin/.vmware-vmx-wrapped";
      };
    };

    # Services

    systemd.services."vmware-wrappers" = {
      description = "Create VMVare Wrappers";
      wantedBy = [ "multi-user.target" ];
      before = [
        "vmware-authdlauncher.service"
        "vmware-networks-configuration.service"
        "vmware-networks.service"
        "vmware-usbarbitrator.service"
      ];
      after = [ "systemd-sysusers.service" ];
      serviceConfig.Type = "oneshot";
      serviceConfig.RemainAfterExit = true;
      script = ''
        mkdir -p "${parentWrapperDir}"
        chmod 755 "${parentWrapperDir}"
        # We want to place the tmpdirs for the wrappers to the parent dir.
        wrapperDir=$(mktemp --directory --tmpdir="${parentWrapperDir}" wrappers.XXXXXXXXXX)
        chmod a+rx "$wrapperDir"
        ${lib.concatStringsSep "\n" (vmwareWrappers)}
        if [ -L ${wrapperDir} ]; then
          # Atomically replace the symlink
          # See https://axialcorps.com/2013/07/03/atomically-replacing-files-and-directories/
          old=$(readlink -f ${wrapperDir})
          if [ -e "${wrapperDir}-tmp" ]; then
            rm --force --recursive "${wrapperDir}-tmp"
          fi
          ln --symbolic --force --no-dereference "$wrapperDir" "${wrapperDir}-tmp"
          mv --no-target-directory "${wrapperDir}-tmp" "${wrapperDir}"
          rm --force --recursive "$old"
        else
          # For initial setup
          ln --symbolic "$wrapperDir" "${wrapperDir}"
        fi
      '';
    };

    systemd.services."vmware-authdlauncher" = {
      description = "VMware Authentication Daemon";
      serviceConfig = {
        Type = "forking";
        ExecStart = [ "${cfg.package}/bin/vmware-authdlauncher" ];
      };
      wantedBy = [ "multi-user.target" ];
    };

    systemd.services."vmware-networks-configuration" = {
      description = "VMware Networks Configuration Generation";
      unitConfig.ConditionPathExists = "!/etc/vmware/networking";
      serviceConfig = {
        UMask = "0077";
        ExecStart = [
          "${cfg.package}/bin/vmware-networks --postinstall vmware-player,0,1"
        ];
        Type = "oneshot";
        RemainAfterExit = "yes";
      };
      wantedBy = [ "multi-user.target" ];
    };

    systemd.services."vmware-networks" = {
      description = "VMware Networks";
      after = [ "vmware-networks-configuration.service" ];
      requires = [ "vmware-networks-configuration.service" ];
      serviceConfig = {
        Type = "forking";
        ExecCondition = [ "${pkgs.kmod}/bin/modprobe vmnet" ];
        ExecStart = [ "${cfg.package}/bin/vmware-networks --start" ];
        ExecStop = [ "${cfg.package}/bin/vmware-networks --stop" ];
      };
      wantedBy = [ "multi-user.target" ];
    };

    systemd.services."vmware-usbarbitrator" = {
      description = "VMware USB Arbitrator";
      serviceConfig = {
        ExecStart = [ "${cfg.package}/bin/vmware-usbarbitrator -f" ];
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
