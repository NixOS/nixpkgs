{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.virtualisation.virtualbox.host;

  virtualbox = cfg.package.override {
    inherit (cfg)
      enableHardening
      headless
      enableWebService
      enableKvm
      ;
    extensionPack = if cfg.enableExtensionPack then pkgs.virtualboxExtpack else null;
  };

  kernelModules = config.boot.kernelPackages.virtualbox.override {
    inherit virtualbox;
  };

in

{
  options.virtualisation.virtualbox.host = {
    enable = lib.mkEnableOption "VirtualBox" // {
      description = ''
        Whether to enable VirtualBox.

        ::: {.note}
        In order to pass USB devices from the host to the guests, the user
        needs to be in the `vboxusers` group.
        :::
      '';
    };

    enableExtensionPack = lib.mkEnableOption "VirtualBox extension pack" // {
      description = ''
        Whether to install the Oracle Extension Pack for VirtualBox.

        ::: {.important}
        You must set `nixpkgs.config.allowUnfree = true` in
        order to use this.  This requires you accept the VirtualBox PUEL.
        :::
      '';
    };

    package = lib.mkPackageOption pkgs "virtualbox" { };

    addNetworkInterface = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Automatically set up a vboxnet0 host-only network interface.
      '';
    };

    enableHardening = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Enable hardened VirtualBox, which ensures that only the binaries in the
        system path get access to the devices exposed by the kernel modules
        instead of all users in the vboxusers group.

        ::: {.important}
        Disabling this can put your system's security at risk, as local users
        in the vboxusers group can tamper with the VirtualBox device files.
        :::
      '';
    };

    headless = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Use VirtualBox installation without GUI and Qt dependency. Useful to enable on servers
        and when virtual machines are controlled only via SSH.
      '';
    };

    enableWebService = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Build VirtualBox web service tool (vboxwebsrv) to allow managing VMs via other webpage frontend tools. Useful for headless servers.
      '';
    };

    enableKvm = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable KVM support for VirtualBox. This increases compatibility with Linux kernel versions, because the VirtualBox kernel modules
        are not required.

        This option is incompatible with `addNetworkInterface`.

        Note: This is experimental. Please check <https://github.com/cyberus-technology/virtualbox-kvm/issues>.
      '';
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        warnings = lib.mkIf (pkgs.config.virtualbox.enableExtensionPack or false) [
          "'nixpkgs.virtualbox.enableExtensionPack' has no effect, please use 'virtualisation.virtualbox.host.enableExtensionPack'"
        ];
        environment.systemPackages = [ virtualbox ];

        security.wrappers =
          let
            mkSuid = program: {
              source = "${virtualbox}/libexec/virtualbox/${program}";
              owner = "root";
              group = "vboxusers";
              setuid = true;
            };
            executables = [
              "VBoxHeadless"
              "VBoxNetAdpCtl"
              "VBoxNetDHCP"
              "VBoxNetNAT"
              "VBoxVolInfo"
            ]
            ++ (lib.optionals (!cfg.headless) [
              "VBoxSDL"
              "VirtualBoxVM"
            ]);
          in
          lib.mkIf cfg.enableHardening (
            builtins.listToAttrs (
              map (x: {
                name = x;
                value = mkSuid x;
              }) executables
            )
          );

        users.groups.vboxusers.gid = config.ids.gids.vboxusers;

        services.udev.extraRules = ''
          SUBSYSTEM=="usb_device", ACTION=="add", RUN+="${virtualbox}/libexec/virtualbox/VBoxCreateUSBNode.sh $major $minor $attr{bDeviceClass}"
          SUBSYSTEM=="usb", ACTION=="add", ENV{DEVTYPE}=="usb_device", RUN+="${virtualbox}/libexec/virtualbox/VBoxCreateUSBNode.sh $major $minor $attr{bDeviceClass}"
          SUBSYSTEM=="usb_device", ACTION=="remove", RUN+="${virtualbox}/libexec/virtualbox/VBoxCreateUSBNode.sh --remove $major $minor"
          SUBSYSTEM=="usb", ACTION=="remove", ENV{DEVTYPE}=="usb_device", RUN+="${virtualbox}/libexec/virtualbox/VBoxCreateUSBNode.sh --remove $major $minor"
        '';
      }
      (lib.mkIf cfg.enableKvm {
        assertions = [
          {
            assertion = !cfg.addNetworkInterface;
            message = "VirtualBox KVM only supports standard NAT networking for VMs. Please turn off virtualisation.virtualbox.host.addNetworkInterface.";
          }
        ];
      })
      (lib.mkIf (!cfg.enableKvm) {
        boot.kernelModules = [
          "vboxdrv"
          "vboxnetadp"
          "vboxnetflt"
        ];
        boot.extraModulePackages = [ kernelModules ];

        services.udev.extraRules = ''
          KERNEL=="vboxdrv",    OWNER="root", GROUP="vboxusers", MODE="0660", TAG+="systemd"
          KERNEL=="vboxdrvu",   OWNER="root", GROUP="root",      MODE="0666", TAG+="systemd"
          KERNEL=="vboxnetctl", OWNER="root", GROUP="vboxusers", MODE="0660", TAG+="systemd"
        '';

        # Since we lack the right setuid/setcap binaries, set up a host-only network by default.
      })
      (lib.mkIf cfg.addNetworkInterface {
        systemd.services.vboxnet0 = {
          description = "VirtualBox vboxnet0 Interface";
          requires = [ "dev-vboxnetctl.device" ];
          after = [ "dev-vboxnetctl.device" ];
          wantedBy = [
            "network.target"
            "sys-subsystem-net-devices-vboxnet0.device"
          ];
          path = [ virtualbox ];
          serviceConfig.RemainAfterExit = true;
          serviceConfig.Type = "oneshot";
          serviceConfig.PrivateTmp = true;
          environment.VBOX_USER_HOME = "/tmp";
          script = ''
            if ! [ -e /sys/class/net/vboxnet0 ]; then
              VBoxManage hostonlyif create
              cat /tmp/VBoxSVC.log >&2
            fi
          '';
          postStop = ''
            VBoxManage hostonlyif remove vboxnet0
          '';
        };

        networking.interfaces.vboxnet0.ipv4.addresses = [
          {
            address = "192.168.56.1";
            prefixLength = 24;
          }
        ];
        # Make sure NetworkManager won't assume this interface being up
        # means we have internet access.
        networking.networkmanager.unmanaged = [ "vboxnet0" ];
      })
      (lib.mkIf config.networking.useNetworkd {
        systemd.network.networks."40-vboxnet0".extraConfig = ''
          [Link]
          RequiredForOnline=no
        '';
      })

    ]
  );
}
