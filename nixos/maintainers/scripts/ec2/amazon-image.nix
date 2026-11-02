# Tests in: nixos/tests/ec2-image.nix
{
  config,
  options,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkDefault
    mkIf
    mkMerge
    mkOption
    optionalString
    types
    ;
  inherit (lib.options) literalExpression;
  cfg = config.amazonImage;
  inherit (config.ec2) bootMode;
  efiBoot = bootMode != "legacy-bios";
  biosBoot = bootMode != "uefi";
  inherit (config.boot.loader) efi;
  systemdBoot = config.boot.loader.systemd-boot.enable;
  grubDevices = lib.remove "nodev" config.boot.loader.grub.devices;
  inherit (config.system.build) toplevel;

  configFile = pkgs.writeText "configuration.nix" ''
    { modulesPath, ... }: {
      imports = [ "''${modulesPath}/virtualisation/amazon-image.nix" ];
      ec2.bootMode = "${bootMode}";
      ${optionalString systemdBoot ''
        boot.loader.systemd-boot.enable = true;
      ''}
      ${optionalString (efiBoot && efi.efiSysMountPoint != "/boot") ''
        boot.loader.efi.efiSysMountPoint = "${efi.efiSysMountPoint}";
      ''}
      ${optionalString config.ec2.zfs.enable ''
        ec2.zfs.enable = true;
        networking.hostId = "${config.networking.hostId}";
      ''}
    }
  '';

  # Initial contents of root's nixos channel.
  # FIXME: merge with channel.nix / make-channel.nix.
  channelSources = pkgs.runCommand "nixos-${config.system.nixos.version}" { } ''
    mkdir -p "$out"
    cp -prd ${lib.cleanSource pkgs.path} "$out/nixos"
    chmod -R u+w "$out/nixos"
    if [ ! -e "$out/nixos/nixpkgs" ]; then
      ln -s . "$out/nixos/nixpkgs"
    fi
    rm -rf "$out/nixos/.git"
    echo -n ${config.system.nixos.versionSuffix} > "$out/nixos/.version-suffix"
  '';

  storePaths = [
    toplevel
  ]
  ++ lib.optional (config.nix.enable && config.nix.channel.enable) channelSources;

  autoSize = config.virtualisation.diskSize == "auto";

  repartImage = config.image.repart.image.overrideAttrs (previousAttrs: {
    nativeBuildInputs = previousAttrs.nativeBuildInputs ++ [
      pkgs.buildPackages.jq
      pkgs.buildPackages.qemu-utils
    ];
    # Convert the image to amazonImage.format and write the metadata Hydra and NixOS/amis read.
    installPhase = ''
      runHook preInstall

      mkdir -p "$out/nix-support"
      image="$out/${config.image.fileName}"
      ${
        if cfg.format == "raw" then
          ''mv ${config.image.baseName}.raw "$image"''
        else
          ''qemu-img convert -f raw -O ${cfg.format} ${config.image.baseName}.raw "$image"''
      }
      echo "file ${cfg.format} $image" >> "$out/nix-support/hydra-build-products"

      jq -n \
        --arg system_version ${lib.escapeShellArg config.system.nixos.version} \
        --arg system ${lib.escapeShellArg pkgs.stdenv.hostPlatform.system} \
        --arg logical_bytes "$(qemu-img info --output json "$image" | jq '."virtual-size"')" \
        --arg boot_mode "${bootMode}" \
        --arg file "$image" \
        '{}
         | .label = $system_version
         | .boot_mode = $boot_mode
         | .system = $system
         | .logical_bytes = $logical_bytes
         | .file = $file
         | .disks.root.logical_bytes = $logical_bytes
         | .disks.root.file = $file
         ' > "$out/nix-support/image-info.json"

      runHook postInstall
    '';
  });

  # Run the systemd-boot installer into the build directory, so the store holds
  # no extra copies of the kernel and initrd.
  systemdBootImage = repartImage.overrideAttrs (previousAttrs: {
    nativeBuildInputs = previousAttrs.nativeBuildInputs ++ [ pkgs.buildPackages.bubblewrap ];
    postPatch = ''
      mkdir -p esp root/{etc,tmp,nix/var/nix/profiles}
      ln -s ${config.environment.etc."os-release".source} root/etc/os-release
      ${optionalString (config.environment.etc ? machine-id) ''
        ln -s ${config.environment.etc.machine-id.source} root/etc/machine-id
      ''}
      ln -s ${toplevel} root/nix/var/nix/profiles/system-1-link
      ln -s system-1-link root/nix/var/nix/profiles/system

      bwrap \
        --bind "$PWD/root" / \
        --bind "$PWD/esp" ${efi.efiSysMountPoint} \
        --ro-bind ${builtins.storeDir} ${builtins.storeDir} \
        --proc /proc \
        --dev /dev \
        --setenv NIXOS_INSTALL_BOOTLOADER 1 \
        --setenv SYSTEMD_RELAX_ESP_CHECKS 1 \
        --setenv NIX_REMOTE "dummy://" \
        --setenv TMPDIR /tmp \
        -- ${config.system.build.installBootLoader} ${toplevel}

      # systemd-boot-random-seed.service writes a seed for each instance on first boot.
      rm -f esp/loader/random-seed
      echo "CopyFiles=$PWD/esp:/" >> repart.d/esp.conf
    '';
  });

  # GRUB only installs onto a mounted disk, so this runs in a VM. This derivation
  # also builds the raw image, so the store never holds an intermediate copy.
  grubImage = pkgs.vmTools.runInLinuxVM (
    repartImage.overrideAttrs {
      memSize = 1024;
      preVM = ''
        runPhase patchPhase
        runPhase buildPhase
        diskImage=$PWD/${config.image.baseName}.raw
      '';
      postVM = "runPhase installPhase";
      buildCommand = ''
        root=/mnt
        mkdir -p $root
        mount -L nixos $root
        ${optionalString efiBoot ''
          mkdir -p $root${efi.efiSysMountPoint}
          mount -L ESP $root${efi.efiSysMountPoint}
        ''}
        # GRUB lists the generations from the profile links.
        mkdir -p $root/nix/var/nix/profiles
        ln -s ${toplevel} $root/nix/var/nix/profiles/system-1-link
        ln -s system-1-link $root/nix/var/nix/profiles/system

        ${lib.concatMapStrings (device: ''
          mkdir -p "$(dirname ${device})"
          ln -s /dev/vda ${device}
        '') grubDevices}
        for dir in dev proc sys; do
          mkdir -p $root/$dir
          mount --rbind /$dir $root/$dir
        done
        mkdir -p $root/tmp
        mount -t tmpfs tmpfs $root/tmp
        # GRUB needs an mtab.
        ln -s /proc/mounts $root/etc/mtab
        NIXOS_INSTALL_BOOTLOADER=1 chroot $root ${config.system.build.installBootLoader} ${toplevel}
        rm $root/etc/mtab
        umount -R $root
      '';
    }
  );
in
{
  imports = [
    ../../../modules/virtualisation/amazon-image.nix
    ../../../modules/virtualisation/disk-size-option.nix
    ../../../modules/image/file-options.nix
    ../../../modules/image/repart.nix
    (lib.mkRenamedOptionModuleWith {
      sinceRelease = 2411;
      from = [
        "amazonImage"
        "sizeMB"
      ];
      to = [
        "virtualisation"
        "diskSize"
      ];
    })
    (lib.mkRenamedOptionModuleWith {
      sinceRelease = 2505;
      from = [
        "amazonImage"
        "name"
      ];
      to = [
        "image"
        "baseName"
      ];
    })
  ];

  options.amazonImage = {
    contents = mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            source = mkOption {
              type = types.path;
              description = "File or directory to copy.";
            };
            target = mkOption {
              type = types.str;
              description = "Where to copy it, relative to the root of the image.";
            };
          };
        }
      );
      example = literalExpression ''
        [ { source = pkgs.memtest86 + "/memtest.bin";
            target = "boot/memtest.bin";
          }
        ]
      '';
      default = [ ];
      description = "Files to copy to fixed locations in the root file system of the image.";
    };

    format = mkOption {
      type = types.enum [
        "raw"
        "qcow2"
        "vpc"
      ];
      default = "vpc";
      description = "The image format to output";
    };
  };

  config = mkMerge [
    {
      # Use a priority just below mkOptionDefault (1500) instead of lib.mkDefault
      # to avoid breaking existing configs using that.
      virtualisation.diskSize = lib.mkOverride 1490 (4 * 1024);
      virtualisation.diskSizeAutoSupported = !config.ec2.zfs.enable;

      system.nixos.tags = [ "amazon" ];
      system.build.image = config.system.build.amazonImage;
      image.extension = if cfg.format == "vpc" then "vhd" else cfg.format;
    }

    (mkIf (!config.ec2.zfs.enable) {
      assertions = [
        {
          # systemd-repart skips sources it can't find, so a glob would copy nothing without an error.
          assertion = lib.all (file: !lib.hasInfix "*" (toString file.source)) cfg.contents;
          message = "amazonImage.contents does not support glob patterns in `source`.";
        }
      ];

      ec2.bootMode = mkDefault (if config.ec2.efi then "uefi" else "uefi-preferred");
      # Only legacy BIOS needs GRUB, and systemd-boot installs without a VM.
      boot.loader.systemd-boot.enable = mkDefault (bootMode == "uefi");
      # GRUB reads the root file system, so only its EFI binary goes on the ESP.
      boot.loader.efi.efiSysMountPoint = mkIf (!systemdBoot) (mkDefault "/boot/efi");

      # Nothing runs nixos-install on the image, so register the store paths and
      # set up the profiles on first boot.
      systemd.services.register-nix-paths = mkIf config.nix.enable {
        description = "Register Nix Store Paths";
        unitConfig = {
          DefaultDependencies = false;
          ConditionPathExists = "/nix-path-registration";
        };
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
        };
        script =
          let
            nix-env = lib.getExe' config.nix.package.out "nix-env";
          in
          ''
            ${lib.getExe' config.nix.package.out "nix-store"} --load-db < /nix-path-registration
            ${nix-env} -p /nix/var/nix/profiles/system --set /run/current-system
            ${optionalString config.nix.channel.enable ''
              mkdir -p /nix/var/nix/profiles/per-user/root
              ${nix-env} -p /nix/var/nix/profiles/per-user/root/channels --set ${channelSources}
              install -m 0700 -d /root/.nix-defexpr
              ln -sfn /nix/var/nix/profiles/per-user/root/channels /root/.nix-defexpr/channels
            ''}
            rm /nix-path-registration
          '';
      };

      image.repart = {
        enable = true;
        # repart derives image.baseName from this; keep its usual default.
        name = options.image.baseName.default;
        imageSize = if autoSize then "auto" else "${toString config.virtualisation.diskSize}M";
        partitions = {
          bios-boot = mkIf biosBoot {
            repartConfig = {
              Type = "21686148-6449-6e6f-744e-656564454649";
              SizeMinBytes = "1M";
              SizeMaxBytes = "1M";
            };
          };
          esp = mkIf efiBoot {
            repartConfig =
              let
                # systemd-boot keeps kernels on the ESP, while GRUB only puts its EFI binary there.
                size = if systemdBoot then "1G" else "128M";
              in
              {
                Type = "esp";
                Format = "vfat";
                Label = "ESP";
                SizeMinBytes = size;
                SizeMaxBytes = size;
              };
          };
          root = {
            inherit storePaths;
            contents = {
              "/etc/nixos/configuration.nix".source = configFile;
            }
            // lib.optionalAttrs config.nix.enable {
              "/nix-path-registration".source = "${pkgs.closureInfo { rootPaths = storePaths; }}/registration";
            }
            // lib.genAttrs' cfg.contents (
              { source, target }: lib.nameValuePair "/${lib.removePrefix "/" target}" { inherit source; }
            );
            repartConfig = {
              Type = "root";
              Format = config.fileSystems."/".fsType;
              Label = "nixos";
            }
            // lib.optionalAttrs autoSize {
              Minimize = "guess";
              # Free space for the root partition to grow into on first boot.
              PaddingMinBytes = "512M";
            };
          };
        };
      };

      system.build.amazonImage = if systemdBoot then systemdBootImage else grubImage;
    })

    (mkIf config.ec2.zfs.enable {
      system.build.amazonImage = import ../../../lib/make-multi-disk-zfs-image.nix {
        inherit
          lib
          config
          configFile
          pkgs
          ;
        inherit (cfg) contents format;
        name = config.image.baseName;

        includeChannel = true;

        bootSize = 1000; # 1G is the minimum EBS volume

        rootSize = config.virtualisation.diskSize;
        rootPoolProperties = {
          ashift = 12;
          autoexpand = "on";
        };

        datasets = config.ec2.zfs.datasets;

        postVM = ''
           extension=''${rootDiskImage##*.}
           friendlyName=$out/${config.image.baseName}
           rootDisk="$friendlyName.root.$extension"
           bootDisk="$friendlyName.boot.$extension"
           mv "$rootDiskImage" "$rootDisk"
           mv "$bootDiskImage" "$bootDisk"

           mkdir -p $out/nix-support
           echo "file ${cfg.format} $bootDisk" >> $out/nix-support/hydra-build-products
           echo "file ${cfg.format} $rootDisk" >> $out/nix-support/hydra-build-products

          ${pkgs.jq}/bin/jq -n \
            --arg system_version ${lib.escapeShellArg config.system.nixos.version} \
            --arg system ${lib.escapeShellArg pkgs.stdenv.hostPlatform.system} \
            --arg root_logical_bytes "$(${pkgs.qemu_kvm}/bin/qemu-img info --output json "$rootDisk" | ${pkgs.jq}/bin/jq '."virtual-size"')" \
            --arg boot_logical_bytes "$(${pkgs.qemu_kvm}/bin/qemu-img info --output json "$bootDisk" | ${pkgs.jq}/bin/jq '."virtual-size"')" \
            --arg boot_mode "${bootMode}" \
            --arg root "$rootDisk" \
            --arg boot "$bootDisk" \
           '{}
             | .label = $system_version
             | .boot_mode = $boot_mode
             | .system = $system
             | .disks.boot.logical_bytes = $boot_logical_bytes
             | .disks.boot.file = $boot
             | .disks.root.logical_bytes = $root_logical_bytes
             | .disks.root.file = $root
             ' > $out/nix-support/image-info.json
        '';
      };
    })
  ];

  meta.maintainers = with lib.maintainers; [ arianvp ];
}
