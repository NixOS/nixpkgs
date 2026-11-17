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

      # Install the boot loader into the build directory, so the store holds no
      # extra copies of the kernel and initrd.
      mkdir -p esp root/{etc,tmp}
      ln -s ${config.environment.etc."os-release".source} root/etc/os-release
      ${optionalString (config.environment.etc ? machine-id) ''
        ln -s ${config.environment.etc.machine-id.source} root/etc/machine-id
      ''}
      bwrapArgs=()
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
        --setenv NIXOS_INSTALL_BOOTLOADER 1 \
        --setenv SYSTEMD_RELAX_ESP_CHECKS 1 \
        --setenv NIX_REMOTE "dummy://" \
        --setenv TMPDIR /tmp \
        -- ${config.system.build.installBootLoader} ${toplevel}

      # systemd-boot-random-seed.service writes a seed for each instance on first boot.
      rm -f esp/loader/random-seed
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
        {
          assertion = systemdBoot || limine.enable;
          message = "The Amazon image boots with systemd-boot or Limine.";
        }
      ];

      ec2.bootMode = mkDefault (if config.ec2.efi then "uefi" else "uefi-preferred");
      # systemd-boot can't boot legacy BIOS.
      boot.loader.systemd-boot.enable = mkDefault (bootMode == "uefi");
      boot.loader.limine.enable = mkDefault (bootMode != "uefi");

      image.repart = {
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
            SizeMinBytes = "1G";
            SizeMaxBytes = "1G";
          };
          root = {
            inherit storePaths;
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
            // lib.optionalAttrs autoSize {
              Minimize = "guess";
              # Free space for the root partition to grow into on first boot.
              PaddingMinBytes = "512M";
            };
          };
        };
      };

      system.build.amazonImage = amazonImage;
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
