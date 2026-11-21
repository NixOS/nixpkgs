# Tests in: nixos/tests/ec2-image.nix
{
  config,
  options,
  lib,
  pkgs,
  utils,
  ...
}:

let
  inherit (lib)
    mkDefault
    mkMerge
    mkIf
    mkOption
    optionalString
    types
    ;
  inherit (lib.options) literalExpression;
  cfg = config.amazonImage;
  # RegisterImage's names for the architectures EC2 runs.
  architecture =
    if pkgs.stdenv.hostPlatform.isx86_64 then
      "x86_64"
    else if pkgs.stdenv.hostPlatform.isAarch64 then
      "arm64"
    else
      null;
  jsonFormat = pkgs.formats.json { };
  inherit (config.ec2) bootMode;
  inherit (config.boot.loader) efi limine;
  systemdBoot = config.boot.loader.systemd-boot.enable;
  # The Limine installer writes the BIOS stages to biosDevice.
  limineBios = limine.enable && limine.biosSupport && limine.biosDevice != "nodev";
  inherit (config.system.build) toplevel;

  configFile = pkgs.writeText "configuration.nix" ''
    { modulesPath, ... }: {
      imports = [ "''${modulesPath}/virtualisation/amazon-image.nix" ];
      ec2.bootMode = "${bootMode}";
      ${optionalString systemdBoot ''
        boot.loader.systemd-boot.enable = true;
      ''}
      ${optionalString limine.enable ''
        boot.loader.limine.enable = true;
      ''}
      ${optionalString (efi.efiSysMountPoint != "/boot") ''
        boot.loader.efi.efiSysMountPoint = "${efi.efiSysMountPoint}";
      ''}
      ${optionalString erofsStore ''
        fileSystems = ${lib.generators.toPretty { indent = "  "; } storeFileSystems};
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
  erofsStore = cfg.store != "root";
  inherit (config.boot.kernelPackages) kernel;
  # Kernels built from a config file list their options in `config`. nixpkgs
  # kernels declare theirs in the structured configuration.
  kernelOption =
    option:
    if (kernel.config.isSet or (_: false)) option then
      kernel.config.getValue option
    else
      kernel.configfile.structuredConfig.${option}.tristate or null;
  erofsZstd = lib.elem (kernelOption "EROFS_FS_ZIP_ZSTD") [
    "y"
    "m"
  ];
  # EROFS_FS_ZIP, which includes LZ4, is on unless something turns it off.
  erofsLz4 = kernelOption "EROFS_FS_ZIP" != "n";
  readOnlyStore = cfg.store == "erofs";
  firstBootRoot = cfg.root == "first-boot";
  rootLabel = "nixos";
  # The disk with the store partition.
  bootDisk = "/dev/disk/amazon-image-boot";
  isBootDisk = pkgs.writeShellScript "amazon-image-is-boot-disk" ''
    while read -r name; do
      [[ $name == nix-store ]] && exit 0
    done < <(${lib.getExe' pkgs.util-linux "partx"} --show --noheadings --output NAME "$1" 2> /dev/null)
    exit 1
  '';
  # systemd-repart doesn't label erofs file systems.
  storeDevice = "/dev/disk/by-partlabel/nix-store";
  storeFileSystems =
    {
      root = { };
      erofs."/nix/store" = {
        device = storeDevice;
        fsType = "erofs";
      };
      erofs-overlay = {
        "/nix/.ro-store" = {
          device = storeDevice;
          fsType = "erofs";
          neededForBoot = true;
        };
        "/nix/store".overlay = {
          lowerdir = [ "/nix/.ro-store" ];
          upperdir = "/nix/.rw-store/upper";
          workdir = "/nix/.rw-store/work";
        };
      };
    }
    .${cfg.store};

  # The format name that AWS ImportSnapshot uses.
  diskFormat =
    {
      raw = "RAW";
      vpc = "VHD";
      qcow2 = "QCOW2";
    }
    .${cfg.format};

  amazonImage = config.image.repart.image.overrideAttrs (previousAttrs: {
    nativeBuildInputs = previousAttrs.nativeBuildInputs ++ [
      pkgs.buildPackages.bubblewrap
      pkgs.buildPackages.jq
      pkgs.buildPackages.qemu-utils
    ];
    postPatch = ''
      # Set up /nix/var/nix and root's channel the way nixos-install does.
      mkdir -p nix-state/profiles
      ln -s ${toplevel} nix-state/profiles/system-1-link
      ${optionalString limine.enable ''
        # Limine shows its mtime as the build date.
        touch -h -d "@$SOURCE_DATE_EPOCH" nix-state/profiles/system-1-link
      ''}
      ln -s system-1-link nix-state/profiles/system
      ${optionalString config.nix.enable ''
        NIX_STATE_DIR=$PWD/nix-state ${lib.getExe' config.nix.package.out "nix-store"} --load-db \
          < ${pkgs.closureInfo { rootPaths = storePaths; }}/registration
        # Keep the image reproducible.
        ${lib.getExe' pkgs.buildPackages.sqlite "sqlite3"} nix-state/db/db.sqlite \
          "UPDATE ValidPaths SET registrationTime = $SOURCE_DATE_EPOCH"
        # Nix recreates its reserved space when it opens the store.
        rm nix-state/db/reserved
      ''}
      ${optionalString (config.nix.enable && config.nix.channel.enable) ''
        mkdir -p nix-state/profiles/per-user/root root-home/.nix-defexpr
        ln -s ${channelSources} nix-state/profiles/per-user/root/channels-1-link
        ln -s channels-1-link nix-state/profiles/per-user/root/channels
        ln -s /nix/var/nix/profiles/per-user/root/channels root-home/.nix-defexpr/channels
        chmod 0700 root-home root-home/.nix-defexpr
        echo "CopyFiles=$PWD/root-home:/root" >> repart.d/root.conf
      ''}
      ${optionalString (!firstBootRoot) ''
        echo "CopyFiles=$PWD/nix-state:/nix/var/nix" >> repart.d/root.conf
      ''}

      # Install the boot loader into the build directory, so the store holds no
      # extra copies of the kernel and initrd.
      mkdir -p esp root/tmp
      bwrapArgs=()
      ${optionalString systemdBoot ''
        # bootctl reads os-release.
        mkdir -p root/etc
        ln -s ${config.environment.etc."os-release".source} root/etc/os-release
        ${optionalString (config.environment.etc ? machine-id) ''
          ln -s ${config.environment.etc.machine-id.source} root/etc/machine-id
        ''}
        bwrapArgs+=(--setenv NIXOS_INSTALL_BOOTLOADER 1 --setenv SYSTEMD_RELAX_ESP_CHECKS 1)
      ''}
      ${optionalString limineBios ''
        # postBuild installs the BIOS stages into the image, so give the
        # installer a scratch disk.
        truncate -s 2M bios-scratch.raw
        echo "type=21686148-6449-6E6F-744E-656564454649" | sfdisk -q -X gpt bios-scratch.raw
        bwrapArgs+=(--bind "$PWD/bios-scratch.raw" ${limine.biosDevice})
      ''}
      bwrap \
        --bind "$PWD/root" / \
        --bind "$PWD/esp" ${efi.efiSysMountPoint} \
        --ro-bind ${builtins.storeDir} ${builtins.storeDir} \
        --bind "$PWD/nix-state" /nix/var/nix \
        --proc /proc \
        --dev /dev \
        "''${bwrapArgs[@]}" \
        --setenv NIX_REMOTE "dummy://" \
        --setenv TMPDIR /tmp \
        -- ${config.system.build.installBootLoader} ${toplevel}

      ${optionalString systemdBoot ''
        # systemd-boot-random-seed.service writes a seed for each instance on first boot.
        rm -f esp/loader/random-seed
      ''}
      # Leave room for the FAT and, with a writable store, a second generation.
      espBytes=$(numfmt --from=iec ${cfg.espSize})
      bootBytes=$(du -sb esp | cut -f1)
      if (( bootBytes * ${if readOnlyStore then "1" else "2"} + espBytes / 20 > espBytes )); then
        echo "amazonImage.espSize = ${cfg.espSize} is too small for $bootBytes bytes of boot files${
          optionalString (!readOnlyStore) ", plus as much again for a second generation"
        }." >&2
        exit 1
      fi
      echo "CopyFiles=$PWD/esp:/" >> repart.d/esp.conf
    '';
    postBuild = optionalString limineBios ''
      ${lib.getExe' limine.package "limine"} bios-install ${config.image.baseName}.raw
    '';
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

      logicalBytes=$(qemu-img info --output json "$image" | jq '."virtual-size"')
      # logical_bytes stays a string in image-info.json for compatibility.
      jq -n \
        --arg system_version ${lib.escapeShellArg config.system.nixos.version} \
        --arg system ${lib.escapeShellArg pkgs.stdenv.hostPlatform.system} \
        --arg logical_bytes "$logicalBytes" \
        --arg boot_mode "${bootMode}" \
        --arg format ${diskFormat} \
        --arg store ${cfg.store} \
        --slurpfile repart repart-output.json \
        --arg file "$image" \
        '{}
         | .label = $system_version
         | .boot_mode = $boot_mode
         | .system = $system
         | .logical_bytes = $logical_bytes
         | .format = $format
         | .store = $store
         | { "ESP": "esp", "nixos": "root", "nix-store": "store" } as $keys
         | .partitions = ([ $repart[0][]
             | { key: $keys[.label], value: { label, number: (.partno + 1), size: .raw_size } }
             | select(.key) ] | from_entries)
         | .file = $file
         | .disks.root.logical_bytes = $logical_bytes
         | .disks.root.file = $file
         ' > "$out/nix-support/image-info.json"

      # RegisterImage rejects a root volume smaller than the snapshot.
      jq --argjson logical_bytes "$logicalBytes" '
        ($logical_bytes / (1024 * 1024 * 1024) | ceil) as $image_gib
        | .RootDeviceName as $root
        | .BlockDeviceMappings |= map(
            if .DeviceName == $root then .Ebs.VolumeSize |= ([., $image_gib] | max) else . end
          )
        | del(.. | nulls)
        ' ${jsonFormat.generate "register-image.json" cfg.registerImage} \
        > "$out/nix-support/register-image.json"

      runHook postInstall
    '';
  });
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
    root = mkOption {
      type = types.enum [
        "image"
        "first-boot"
      ];
      default = "image";
      description = ''
        Where the root file system comes from.

        - `"image"` ships it in the image, and instances grow it to fill the
          volume.
        - `"first-boot"` leaves it out. systemd-repart creates it in the initrd
          on first boot, at the volume's full size. Needs `store = "erofs"` and
          `nix.enable = false`. {file}`image-info.json` then has no
          `partitions.root`.
      '';
    };

    rootFsType = mkOption {
      type = types.enum [
        "ext4"
        "xfs"
      ];
      default = "ext4";
      description = ''
        File system of the root partition that `root = "first-boot"` creates.
      '';
    };

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
      description = ''
        Files to copy to fixed locations in the root file system of the image.
        With `root = "first-boot"`, systemd-tmpfiles copies them on every boot
        where they are missing, so a deleted file comes back.
      '';
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

    store = mkOption {
      type = types.enum [
        "root"
        "erofs"
        "erofs-overlay"
      ];
      default = "root";
      description = ''
        Where the Nix store lives.

        - `"root"` keeps it on the root file system.
        - `"erofs"` puts it on its own compressed, read-only partition.
          Instances can use and verify the store but can't add to it, so
          `nixos-rebuild`, channels and garbage collection don't work on them.
          The image has no channel.
        - `"erofs-overlay"` adds a writable overlay on the root file system,
          so Nix, `nixos-rebuild` and the channel work as with `"root"`.
          Garbage collection hides paths from the image but can't free their
          space.
      '';
    };

    espSize = mkOption {
      type = types.str;
      default = "1G";
      example = "256M";
      description = ''
        Size of the EFI system partition, which holds the boot loader and the
        kernel and initrd of each generation. The image build fails if they
        don't fit. Unless the store is read-only, it also needs room for a
        second generation.
      '';
    };

    storeCompression = mkOption {
      type = types.enum [
        "zstd"
        "lz4hc"
      ];
      default = if erofsZstd then "zstd" else "lz4hc";
      defaultText = lib.literalMD ''`"zstd"` if the kernel enables `EROFS_FS_ZIP_ZSTD`, otherwise `"lz4hc"`'';
      description = ''
        Compression of an erofs Nix store. `"zstd"` makes a smaller image but
        needs a kernel with `EROFS_FS_ZIP_ZSTD`. `"lz4hc"` only needs
        `EROFS_FS_ZIP`, which kernels enable by default.
      '';
    };

    registerImage = mkOption {
      type = types.submodule (
        { config, ... }:
        {
          freeformType = jsonFormat.type;
          options = {
            RootDeviceName = mkOption {
              type = types.str;
              default = "/dev/xvda";
              description = "Device name of the root volume.";
            };

            BlockDeviceMappings = mkOption {
              type = types.listOf jsonFormat.type;
              default = [
                {
                  DeviceName = config.RootDeviceName;
                  Ebs = {
                    VolumeType = "gp3";
                    VolumeSize = 4;
                  };
                }
              ];
              defaultText = literalExpression ''
                [
                  {
                    DeviceName = config.amazonImage.registerImage.RootDeviceName;
                    Ebs = {
                      VolumeType = "gp3";
                      VolumeSize = 4;
                    };
                  }
                ]
              '';
              description = ''
                Volumes of instances launched from the AMI. The uploader attaches the
                image's snapshot to the mapping for `RootDeviceName`, whose
                `Ebs.VolumeSize` in GiB is raised to fit the image.
              '';
            };

            Architecture = mkOption {
              type = types.enum [
                "i386"
                "x86_64"
                "arm64"
                "x86_64_mac"
                "arm64_mac"
              ];
              default = architecture;
              defaultText = lib.literalMD ''`"x86_64"` or `"arm64"`, matching the image'';
              description = "Architecture of the image.";
            };

            BootMode = mkOption {
              type = types.enum [
                "legacy-bios"
                "uefi"
                "uefi-preferred"
              ];
              default = bootMode;
              defaultText = literalExpression "config.ec2.bootMode";
              description = ''
                How instances boot the image. Only an image built with
                `ec2.bootMode = "uefi-preferred"` can be registered with another
                `BootMode`.
              '';
            };

            VirtualizationType = mkOption {
              type = types.enum [
                "hvm"
                "paravirtual"
              ];
              default = "hvm";
              description = "Virtualization type of instances.";
            };

            EnaSupport = mkOption {
              type = types.bool;
              default = true;
              description = "Whether instances use the Elastic Network Adapter.";
            };

            SriovNetSupport = mkOption {
              type = types.nullOr (types.enum [ "simple" ]);
              default = "simple";
              description = "Set to `null` to turn off enhanced networking with the Intel 82599 VF interface.";
            };

            ImdsSupport = mkOption {
              type = types.nullOr (types.enum [ "v2.0" ]);
              default = "v2.0";
              description = "Set to `null` to let instances also use IMDSv1.";
            };

            TpmSupport = mkOption {
              type = types.nullOr (types.enum [ "v2.0" ]);
              default = null;
              description = ''
                Set to `"v2.0"` to give instances a NitroTPM. Requires
                `BootMode = "uefi"`.
              '';
            };
          };
        }
      );
      default = { };
      description = ''
        Arguments to [RegisterImage](https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_RegisterImage.html)
        for AMI uploaders such as [NixOS/amis](https://github.com/NixOS/amis),
        written to {file}`nix-support/register-image.json`. The uploader adds
        `Name`, the image's snapshot and tags. `null` leaves an argument out.
      '';
      example = literalExpression ''
        {
          TpmSupport = "v2.0";
          BlockDeviceMappings = [
            {
              DeviceName = "/dev/xvda";
              Ebs = {
                VolumeType = "gp3";
                VolumeSize = 8;
              };
            }
          ];
        }
      '';
    };
  };

  config = {
    system.nixos.tags = [ "amazon" ];
    system.build.image = config.system.build.amazonImage;
    image.extension = if cfg.format == "vpc" then "vhd" else cfg.format;

    assertions = [
      {
        assertion = architecture != null;
        message = "amazonImage only builds x86_64 and aarch64 images, not ${pkgs.stdenv.hostPlatform.system}. RegisterImage rejects some other architecture names, such as riscv64's \"riscv\".";
      }
      {
        assertion = readOnlyStore -> !(config.nix.gc.automatic || config.nix.optimise.automatic);
        message = "nix.gc.automatic and nix.optimise.automatic need a writable Nix store, but amazonImage.store = \"erofs\" makes it read-only.";
      }
      {
        assertion = erofsStore -> config.boot.initrd.supportedFilesystems.erofs or false;
        message = "amazonImage.store = \"${cfg.store}\" mounts the Nix store in the initrd, which needs boot.initrd.supportedFilesystems.erofs.";
      }
      {
        assertion = erofsStore && cfg.storeCompression == "zstd" -> erofsZstd;
        message = "amazonImage.storeCompression = \"zstd\" needs a kernel with EROFS_FS_ZIP_ZSTD. Enable it or use \"lz4hc\".";
      }
      {
        assertion = erofsStore && cfg.storeCompression == "lz4hc" -> erofsLz4;
        message = "amazonImage.storeCompression = \"lz4hc\" needs a kernel with EROFS_FS_ZIP.";
      }
      {
        # systemd-repart skips sources it can't find, so a glob would copy nothing without an error.
        assertion = lib.all (file: !lib.hasInfix "*" (toString file.source)) cfg.contents;
        message = "amazonImage.contents does not support glob patterns in `source`.";
      }
      {
        assertion = firstBootRoot -> readOnlyStore;
        message = "amazonImage.root = \"first-boot\" needs amazonImage.store = \"erofs\", so that the image holds the whole system without a root partition.";
      }
      {
        assertion = firstBootRoot -> !config.nix.enable;
        message = "amazonImage.root = \"first-boot\" needs nix.enable = false. Nix keeps its database on the root file system, which the image doesn't have.";
      }
      {
        assertion = cfg.rootFsType != "ext4" -> firstBootRoot;
        message = "amazonImage.rootFsType only applies to amazonImage.root = \"first-boot\".";
      }
      {
        assertion = systemdBoot || limine.enable;
        message = "The Amazon image boots with systemd-boot or Limine.";
      }
      {
        assertion = cfg.registerImage.TpmSupport != null -> cfg.registerImage.BootMode == "uefi";
        message = "amazonImage.registerImage.TpmSupport requires amazonImage.registerImage.BootMode = \"uefi\".";
      }
      {
        # A hybrid image boots either way. The others boot only their own way.
        assertion =
          cfg.registerImage.BootMode == bootMode
          ||
            bootMode == "uefi-preferred"
            && lib.elem cfg.registerImage.BootMode [
              "legacy-bios"
              "uefi"
            ];
        message = "amazonImage.registerImage.BootMode = \"${toString cfg.registerImage.BootMode}\" can't boot an image built with ec2.bootMode = \"${bootMode}\".";
      }
      {
        assertion =
          lib.count (
            mapping: (mapping.DeviceName or null) == cfg.registerImage.RootDeviceName
          ) cfg.registerImage.BlockDeviceMappings == 1;
        message = "amazonImage.registerImage.BlockDeviceMappings needs exactly one mapping for RootDeviceName.";
      }
    ];

    ec2.bootMode = mkDefault (if config.ec2.efi then "uefi" else "uefi-preferred");

    # Grow root, the last partition, in the initrd instead of with growpart.
    boot.initrd.systemd.repart.enable = mkDefault true;
    systemd.repart.partitions.root = {
      Type = "root";
    }
    # With root = "first-boot", systemd-repart creates root instead.
    // lib.optionalAttrs firstBootRoot {
      Format = cfg.rootFsType;
      Label = rootLabel;
    };
    # There is no root yet to find the disk by.
    boot.initrd.systemd.repart.device = mkIf firstBootRoot bootDisk;
    # A new EBS volume already reads as zeros.
    boot.initrd.systemd.repart.discard = mkIf firstBootRoot (mkDefault false);
    boot.initrd.supportedFilesystems = mkIf firstBootRoot { ${cfg.rootFsType} = true; };
    boot.initrd.systemd.storePaths = mkIf firstBootRoot [
      isBootDisk
      (lib.getExe' pkgs.util-linux "partx")
    ];
    boot.initrd.services.udev.rules = mkIf firstBootRoot ''
      SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", ENV{ID_PART_TABLE_TYPE}=="gpt", PROGRAM="${isBootDisk} $devnode", SYMLINK+="${lib.removePrefix "/dev/" bootDisk}"
    '';
    boot.initrd.systemd.services = mkIf firstBootRoot {
      # A clone of the volume has a store partition too, and could get root.
      amazon-image-boot-disk = {
        description = "Check that one disk holds the Nix store";
        requiredBy = [ "systemd-repart.service" ];
        after = [ "${utils.escapeSystemdPath bootDisk}.device" ];
        before = [
          "systemd-repart.service"
          "initrd-switch-root.target"
          "shutdown.target"
        ];
        conflicts = [
          "initrd-switch-root.target"
          "shutdown.target"
        ];
        unitConfig = {
          DefaultDependencies = false;
          OnFailure = "emergency.target";
          OnFailureJobMode = "replace-irreversibly";
        };
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          StandardError = "journal+console";
        };
        script = ''
          disks=()
          for dev in /sys/block/*; do
            (( $(< "$dev/size") > 0 )) || continue
            if ${isBootDisk} "/dev/''${dev##*/}"; then
              disks+=("/dev/''${dev##*/}")
            fi
          done
          if (( ''${#disks[@]} > 1 )); then
            echo "''${disks[*]} all have a nix-store partition. Not creating root on any of them." >&2
            exit 1
          fi
        '';
      };
    };

    # systemd-boot can't boot legacy BIOS.
    boot.loader.systemd-boot.enable = mkDefault (bootMode == "uefi");
    boot.loader.limine.enable = mkDefault (bootMode != "uefi");

    fileSystems = mkMerge [
      storeFileSystems
      (mkIf firstBootRoot {
        "/" = {
          device = "/dev/disk/by-partlabel/${rootLabel}";
          fsType = cfg.rootFsType;
          autoResize = true;
          options = [ "x-systemd.after=systemd-repart.service" ];
        };
      })
    ];
    # Instances can't update channels on a read-only store.
    nix.channel.enable = mkIf readOnlyStore (mkDefault false);
    # Nix chowns the store to its build group on start, which fails on a read-only store.
    nix.settings.build-users-group = mkIf readOnlyStore (mkDefault "");
    # switch-to-configuration and the boot loader installer need a writable store.
    system.switch.enable = mkIf readOnlyStore (mkDefault false);

    # What the image would otherwise copy into root.
    systemd.tmpfiles.settings.amazon-image = mkIf firstBootRoot (
      {
        "/nix/var/nix/profiles/system".L.argument = "/run/booted-system";
      }
      // lib.genAttrs' cfg.contents (
        { source, target }:
        lib.nameValuePair "/${lib.removePrefix "/" target}" { C.argument = "${source}"; }
      )
    );

    image.repart = {
      # Larger compression clusters make the image about 6% smaller.
      mkfsOptions.erofs = mkIf erofsStore [ "-C65536" ];
      enable = true;
      # repart derives image.baseName from this; keep its usual default.
      name = options.image.baseName.default;
      imageSize = if autoSize then "auto" else "${toString config.virtualisation.diskSize}M";
      partitions = {
        # Limine finds its BIOS stage 2 here.
        bios-boot = mkIf limineBios {
          repartConfig = {
            Type = "21686148-6449-6e6f-744e-656564454649";
            SizeMinBytes = "1M";
            SizeMaxBytes = "1M";
          };
        };
        # Both boot loaders read the kernels from the ESP, also under legacy BIOS.
        esp.repartConfig = {
          Type = "esp";
          Format = "vfat";
          Label = "ESP";
          SizeMinBytes = cfg.espSize;
          SizeMaxBytes = cfg.espSize;
        };
        # It comes before root, so root stays last and can grow.
        nix-store = mkIf erofsStore {
          inherit storePaths;
          nixStorePrefix = "/";
          repartConfig = {
            Type = "linux-generic";
            Format = "erofs";
            Label = "nix-store";
            Minimize = "best";
            Compression = cfg.storeCompression;
            # Nix creates it on start, which fails on a read-only store.
            MakeDirectories = "/.links";
          }
          # Higher levels take several times as long and save a few percent.
          // lib.optionalAttrs (cfg.storeCompression == "zstd") { CompressionLevel = 9; };
        };
        root = mkIf (!firstBootRoot) {
          storePaths = lib.optionals (!erofsStore) storePaths;
          contents = {
            "/etc/nixos/configuration.nix".source = configFile;
          }
          // lib.genAttrs' cfg.contents (
            { source, target }: lib.nameValuePair "/${lib.removePrefix "/" target}" { inherit source; }
          );
          repartConfig = {
            Type = "root";
            Format = config.fileSystems."/".fsType;
            Label = rootLabel;
          }
          // lib.optionalAttrs autoSize { Minimize = "guess"; };
        };
      };
    };

    system.build.amazonImage = amazonImage;
  };

  meta.maintainers = with lib.maintainers; [ arianvp ];
}
