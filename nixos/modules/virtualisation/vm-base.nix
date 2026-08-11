# Backend-neutral pieces of running a NixOS guest in a VM.
#
# `qemu-vm.nix` still carries its own copies of these options: the two modules are
# never imported together because a configuration has exactly one VM backend, so
# the duplicated declarations cannot collide.
# Deduping `qemu-vm.nix` onto this module is a refactor left for later.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.virtualisation;
in
{
  options = {

    virtualisation.memorySize = lib.mkOption {
      type = lib.types.ints.positive;
      default = 1024;
      description = ''
        The memory size in megabytes of the virtual machine.
      '';
    };

    virtualisation.cores = lib.mkOption {
      type = lib.types.ints.positive;
      default = 1;
      description = ''
        Specify the number of cores the guest is permitted to use.
        The number can be higher than the available cores on the
        host system.
      '';
    };

    # `virtualisation.diskSize` comes from `disk-size-option.nix` in the default module list.

    virtualisation.additionalPaths = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = ''
        A list of paths whose closure should be made available to the VM.

        The closure is copied into the VM's Nix store image and registered in
        the guest's Nix database.
      '';
    };

    virtualisation.writableStore = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        If enabled, the Nix store in the VM is made writable by layering an
        overlay filesystem on top of the (read-only) store image.
      '';
    };

    virtualisation.writableStoreUseTmpfs = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Use a tmpfs for the writable store instead of writing to a disk image.

        Turning this off makes store writes survive a reboot, at the cost of
        needing a disk to put them on.
      '';
    };

    virtualisation.useHostCerts = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        If enabled, when `NIX_SSL_CERT_FILE` is set on the host,
        pass the CA certificates from the host to the VM.
      '';
    };

    virtualisation.sharedDirectories = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options.source = lib.mkOption {
              type = lib.types.str;
              description = "The path of the directory to share, can be a shell variable";
            };
            options.target = lib.mkOption {
              type = lib.types.path;
              description = "The mount point of the directory inside the virtual machine";
            };
            options.tag = lib.mkOption {
              type = lib.types.str;
              default = name;
              description = ''
                The tag the guest mounts this share by. Defaults to the attribute
                name. Backends impose their own length limits on tags.
              '';
            };
          }
        )
      );
      default = { };
      example = {
        my-share = {
          source = "/path/to/be/shared";
          target = "/mnt/shared";
        };
      };
      description = ''
        An attribute set of directories that will be shared with the virtual
        machine. The attribute name is used as the mount tag.
      '';
    };

    virtualisation.host.pkgs = lib.mkOption {
      type = lib.types.pkgs;
      default = pkgs;
      defaultText = lib.literalExpression "pkgs";
      example = lib.literalExpression ''
        import pkgs.path { system = "aarch64-darwin"; }
      '';
      description = ''
        Package set to use for the host-side tooling that launches the VM.

        This is not the guest's package set: the host may well be a different
        platform than the guest, which is the entire point of running a VM.
      '';
    };
  };

  config = {

    # Passed on the kernel command line: a direct reference would make the closure self-referential.
    systemd.services.register-nix-paths = lib.mkIf config.nix.enable {
      # Runs early so the store DB is populated first; `--load-db` needs no daemon.
      unitConfig.DefaultDependencies = false;
      wantedBy = [ "sysinit.target" ];
      before = [
        "sysinit.target"
        "shutdown.target"
        "nix-daemon.socket"
        "nix-daemon.service"
      ];
      after = [ "local-fs.target" ];
      conflicts = [ "shutdown.target" ];
      restartIfChanged = false;
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = lib.mkIf (config.nix.daemonUser != "root") config.nix.daemonUser;
        Group = lib.mkIf (config.nix.daemonGroup != "root") config.nix.daemonGroup;
      };
      script = ''
        if [[ "$(cat /proc/cmdline)" =~ regInfo=([^ ]*) ]]; then
          ${lib.getExe' config.nix.package.out "nix-store"} --load-db < "''${BASH_REMATCH[1]}"
        fi
      '';
    };

    virtualisation.additionalPaths = [ config.system.build.toplevel ];

    # Read-only erofs store, overlaid when writable. Override per entry: `mkVMOverride` on
    # the whole set would drop other modules' filesystems, including the Rosetta share.
    fileSystems = {
      "/nix/.ro-store" = lib.mkVMOverride {
        device = "/dev/disk/by-label/nix-store";
        fsType = "erofs";
        neededForBoot = true;
        options = [ "ro" ];
      };
      "/nix/store" = lib.mkVMOverride (
        if cfg.writableStore then
          {
            overlay = {
              lowerdir = [ "/nix/.ro-store" ];
              upperdir = "/nix/.rw-store/upper";
              workdir = "/nix/.rw-store/work";
            };
          }
        else
          {
            device = "/nix/.ro-store";
            fsType = "none";
            options = [ "bind" ];
          }
      );
      "/nix/.rw-store" = lib.mkIf (cfg.writableStore && cfg.writableStoreUseTmpfs) (
        lib.mkVMOverride {
          fsType = "tmpfs";
          options = [ "mode=0755" ];
          neededForBoot = true;
        }
      );
    };

    swapDevices = lib.mkVMOverride [ ];
    boot.initrd.luks.devices = lib.mkVMOverride { };

    # The host keeps time for us.
    services.timesyncd.enable = false;
  };
}
