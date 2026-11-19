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
  # A read-only store has one generation, so the firmware boots its UKI directly.
  ukiBoot = readOnlyStore && bootMode == "uefi";
  # The UKI's command line, as system.build.uki builds it.
  ukiCmdline = config.boot.uki.settings.UKI.Cmdline;
  # systemd-repart doesn't label erofs file systems.
  storeDevice = "/dev/disk/by-partlabel/nix-store";
  storeFileSystems =
    {
      root = { };
      erofs."/nix/store" = {
        device = if cfg.verity then "/dev/mapper/nix-store" else storeDevice;
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

  # With verity, the first systemd-repart run in preBuild creates the image.
  repartImage = config.image.repart.image.override { createEmpty = !cfg.verity; };

  amazonImage = repartImage.overrideAttrs (previousAttrs: {
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
      echo "CopyFiles=$PWD/nix-state:/nix/var/nix" >> repart.d/root.conf

      mkdir -p esp
      echo "CopyFiles=$PWD/esp:/" >> repart.d/esp.conf
    ''
    + optionalString (!ukiBoot) ''
      # Install the boot loader into the build directory, so the store holds no
      # extra copies of the kernel and initrd.
      mkdir -p root/tmp
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
    '';
    preBuild =
      optionalString cfg.verity ''
        # The UKI's command line needs the store's root hash, so the ESP comes in a second run.
        unshare --map-root-user fakeroot systemd-repart ''${systemdRepartFlags[@]} \
          --empty=create --defer-partitions=esp ${config.image.baseName}.raw > repart-store.json
        storehash=$(jq -r '.[] | select(.label == "nix-store") | .roothash' repart-store.json)
      ''
      + optionalString ukiBoot ''
        # With no boot loader, the firmware loads the UKI from the removable-media path.
        mkdir -p esp/EFI/BOOT
        uki=esp/EFI/BOOT/BOOT${lib.toUpper pkgs.stdenv.hostPlatform.efiArch}.EFI
      ''
      + (
        if cfg.verity then
          ''
            # system.build.uki lacks the root hash, and patching it would break .pcrsig and Secure Boot signatures.
            ${lib.getExe' pkgs.buildPackages.systemdUkify "ukify"} build --config=${config.boot.uki.configFile} \
              --cmdline="${ukiCmdline} storehash=$storehash" --output="$uki"
          ''
        else
          optionalString ukiBoot ''
            install -m 644 ${config.system.build.uki}/${config.system.boot.loader.ukiFile} "$uki"
          ''
      )
      + ''
        # Leave room for the FAT and, with a writable store, a second generation.
        espBytes=$(numfmt --from=iec ${cfg.espSize})
        bootBytes=$(du -sb esp | cut -f1)
        if (( bootBytes * ${if readOnlyStore then "1" else "2"} + espBytes / 20 > espBytes )); then
          echo "amazonImage.espSize = ${cfg.espSize} is too small for $bootBytes bytes of boot files${
            optionalString (!readOnlyStore) ", plus as much again for a second generation"
          }." >&2
          exit 1
        fi
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
        --arg store ${cfg.store} ${optionalString cfg.verity ''--arg roothash "$storehash"''} \
        --slurpfile repart repart-output.json \
        --arg file "$image" \
        '{}
         | .label = $system_version
         | .boot_mode = $boot_mode
         | .system = $system
         | .logical_bytes = $logical_bytes
         | .format = $format
         | .store = $store
         | { "ESP": "esp", "nixos": "root", "nix-store": "store", "nix-store-verity": "store-verity" } as $keys
         | .partitions = ([ $repart[0][]
             | { key: $keys[.label], value: { label, number: (.partno + 1), size: .raw_size } }
             | select(.key) ] | from_entries)
         ${optionalString cfg.verity "| .partitions.store.roothash = $roothash"}
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
          The image has no channel. With `ec2.bootMode = "uefi"`, the firmware
          boots a unified kernel image directly, without a boot loader.
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

    verity = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to protect the read-only Nix store with dm-verity. The store's
        root hash goes on the unified kernel image's command line. Requires
        `store = "erofs"` and `ec2.bootMode = "uefi"`.
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
        assertion = systemdBoot || limine.enable || ukiBoot;
        message = "The Amazon image boots with systemd-boot or Limine.";
      }
      {
        assertion = cfg.verity -> ukiBoot;
        message = "amazonImage.verity requires amazonImage.store = \"erofs\" and ec2.bootMode = \"uefi\".";
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
    # systemd-boot can't boot legacy BIOS.
    boot.loader.systemd-boot.enable = mkDefault (bootMode == "uefi" && !ukiBoot);
    boot.loader.limine.enable = mkDefault (bootMode != "uefi");

    boot.loader.grub.enable = mkIf ukiBoot (mkDefault false);
    boot.initrd.systemd.dmVerity.enable = mkIf cfg.verity true;
    boot.initrd.nix-store-veritysetup.enable = mkIf cfg.verity true;

    fileSystems = storeFileSystems;
    # Instances can't update channels on a read-only store.
    nix.channel.enable = mkIf readOnlyStore (mkDefault false);
    # Nix chowns the store to its build group on start, which fails on a read-only store.
    nix.settings.build-users-group = mkIf readOnlyStore (mkDefault "");
    # switch-to-configuration and the boot loader installer need a writable store.
    system.switch.enable = mkIf readOnlyStore (mkDefault false);

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
          // lib.optionalAttrs cfg.verity {
            Verity = "data";
            VerityMatchKey = "nix-store";
          }
          # Higher levels take several times as long and save a few percent.
          // lib.optionalAttrs (cfg.storeCompression == "zstd") { CompressionLevel = 9; };
        };
        nix-store-verity = mkIf cfg.verity {
          repartConfig = {
            Type = "linux-generic";
            Label = "nix-store-verity";
            Verity = "hash";
            VerityMatchKey = "nix-store";
            Minimize = "best";
          };
        };
        root = {
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
            Label = "nixos";
          }
          // lib.optionalAttrs autoSize { Minimize = "guess"; };
        };
      };
    };

    system.build.amazonImage = amazonImage;
  };

  meta.maintainers = with lib.maintainers; [ arianvp ];
}
