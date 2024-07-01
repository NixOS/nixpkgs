{config, pkgs, lib, ...}:
let
  cfg = config.programs.looking-glass;

  # Generate the looking-glass-client configuration where boolean values
  # are encoded as "yes" or "no".
  generateConfig = settings: lib.generators.toINI {
    mkKeyValue = lib.generators.mkKeyValueDefault {
      mkValueString = v:
        if (true == v) then "yes"
        else if (false == v) then "no"
        else (lib.generators.mkValueStringDefault {} v);
    } "=";
  } settings;
in {
  meta = {
    maintainers = with lib.maintainers; [
      calebstewart
    ];

    doc = ./looking-glass.md;
  };

  options.programs.looking-glass = {
    enable = lib.mkEnableOption "looking-glass";
    package = lib.mkPackageOption pkgs "looking-glass-client" {};

    # Options for using the KVM Frame Relay Kernel Module
    kvmfr = {
      enable = lib.mkEnableOption "KVM Frame Relay (kvmfr)";

      package = lib.mkPackageOption config.boot.kernelPackages "kvmfr" {
        pkgsText = "config.boot.kernelPackages";
      };

      owner = lib.mkOption {
        description = "Owner of the kvmfr device file(s). You probably want to set this to the name of the user who will run looking-glass-client.";
        default = "kvm";
        example = "your-user-name";
        type = lib.types.str;
      };

      group = lib.mkOption {
        description = "Group of the kvmfr device file(s)";
        default = "kvm";
        example = "kvm";
        type = lib.types.str;
      };

      sizeMB = lib.mkOption {
        description = "Size (in megabytes) of the kvmfr device";
        default = 32;
        example = 128;
        type = lib.types.ints.positive;
      };

      configureDeviceACLs = lib.mkOption {
        description = ''
          Configure libvirtd's qemu.conf to include the kvmfr device in the
          cgroup_device_acl setting. When enabled, this module adds a block
          to the 'virtualisation.libvirtd.qemu.verbatimConfig' option which
          sets cgroup_device_acl to the default list of devices along with
          the kvmfr0 device. You probably want this enabled unless you
          explicitly set the 'verbatimConfig' option elsewhere.

          If you already set a custom value for cgroup_device_acl, you should
          not enable this option. Instead, add '/dev/kvmfr0' to the setting
          yourself.

          If you do not add '/dev/kvmfr0' to the list or enable this option,
          any VMs attempting to utilize kvmfr will fail to start, and libvirt
          will report a Permission Denied error.
        '';
        default = false;
        example = true;
        type = lib.types.bool;
      };
    };

    # Options for creating the /dev/shm shared memory file
    shm = {
      enable = lib.mkEnableOption "Shared Memory Frame Relay";

      owner = lib.mkOption {
        description = "Owner of the shared memory file";
        default = "kvm";
        example = "your-user-name";
        type = lib.types.str;
      };

      name = lib.mkOption {
        description = "Name of the shared memory file under /dev/shm";
        default = "looking-glass";
        example = "looking-glass";
      };
    };

    # Client configuration (written to /etc/looking-glass-client.ini)
    settings = lib.mkOption {
      description = "Looking Glass client configuration";
      default = {};
      type = lib.types.submodule ./types/default.nix;

      example = {
        app.shmFile = "/dev/kvmfr0";
        input.escapeKey = "KEY_RIGHTCTRL";

        win = {
          fullScreen = true;
          noScreensaver = true;
          showFPS = true;
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    warnings = lib.lists.optional (!cfg.kvmfr.enable && !cfg.shm.enable) ''
    Neither the shared memory nor kvmfr kernel module are enabled.
    You must configure one of these manually or set one of programs.looking-glass.kvmfr.enable
    or programs.looking-glass.shm.enable to have them automatically configured.
    '';

    # Install looking glass
    environment.systemPackages = [cfg.package];

    # Optionally install the kvmfr kernel module
    boot.extraModulePackages = lib.lists.optional cfg.kvmfr.enable cfg.kvmfr.package;

    # Create the configuration file if requested
    environment.etc = {
      # Write the looking glass configuration
      "looking-glass-client.ini".text = generateConfig cfg.settings;

      # Set the frame size if kvmfr is enabled
      "modprobe.d/kvmfr.conf" = {
        enable = cfg.kvmfr.enable;
        text = ''
          options kvmfr static_size_mb=${builtins.toString cfg.kvmfr.sizeMB}
        '';
      };

      # Load the kvmfr module at boot if enabled
      "modules-load.d/kvmfr.conf" = {
        enable = cfg.kvmfr.enable;
        text = ''
          # KVMFR Looking Glass Module
          kvmfr
        '';
      };
    };

    # Automatically apply permissions to the kvmfr device as requested
    services.udev.packages = lib.lists.optional cfg.kvmfr.enable (pkgs.writeTextFile {
      name = "99-looking-glass-kvmfr.rules";
      destination = "/etc/udev/rules.d/99-looking-glass-kvmfr.rules";
      text = ''
        SUBSYSTEM=="kvmfr", OWNER="${cfg.kvmfr.owner}", GROUP="${cfg.kvmfr.group}", MODE="0660"
      '';
    });

    # Create the /dev/shm file if requested
    systemd.tmpfiles.rules = lib.lists.optional cfg.shm.enable ''
      f /dev/shm/${cfg.shm.name} 0660 ${cfg.shm.owner} qemu-libvirtd -
    '';

    # Allow access to the kvmfr device from the libvirt cgroups
    virtualisation.libvirtd.qemu.verbatimConfig = lib.strings.optionalString (cfg.kvmfr.enable && cfg.kvmfr.configureDeviceACLs) ''
      cgroup_device_acl = [
        "/dev/null", "/dev/full", "/dev/zero",
        "/dev/random", "/dev/urandom",
        "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
        "/dev/rtc","/dev/hpet", "/dev/vfio/vfio",
        "/dev/kvmfr0"
      ]
    '';

    # Add libvirt-qemu apparmor policy allowing rw access to kvmfr device if apparmor is enabled
    security.apparmor.packages = lib.lists.optional (cfg.kvmfr.enable && config.security.apparmor.enable) (pkgs.writeTextFile {
      name = "looking-glass-kvmfr-apparmor-policy";
      destination = "/etc/apparmor.d/local/abstractions/libvirt-qemu";
      text = ''
        # Looking Glass
        /dev/kvmfr0 rw,
      '';
    });
  };
}
