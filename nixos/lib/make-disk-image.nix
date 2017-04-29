{ pkgs
, lib

, # The NixOS configuration to be installed onto the disk image.
  config

, # The size of the disk, in megabytes.
  diskSize

  # The files and directories to be placed in the target file system.
  # This is a list of attribute sets {source, target} where `source'
  # is the file system object (regular file or directory) to be
  # grafted in the file system at path `target'.
, contents ? []

, # Whether the disk should be partitioned (with a single partition
  # containing the root filesystem) or contain the root filesystem
  # directly.
  partitioned ? true

  # Whether to invoke switch-to-configuration boot during image creation
, installBootLoader ? true

, # The root file system type.
  fsType ? "ext4"

, # The initial NixOS configuration file to be copied to
  # /etc/nixos/configuration.nix.
  configFile ? null

, # Shell code executed after the VM has finished.
  postVM ? ""

, name ? "nixos-disk-image"

, format ? "raw"
}:

with lib;

let
  # Copied from https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/installer/cd-dvd/channel.nix
  # TODO: factor out more cleanly

  # Do not include these things:
  #   - The '.git' directory
  #   - Result symlinks from nix-build ('result', 'result-2', 'result-bin', ...)
  #   - VIM/Emacs swap/backup files ('.swp', '.swo', '.foo.swp', 'foo~', ...)
  filterFn = path: type: let basename = baseNameOf (toString path); in
    if type == "directory" then basename != ".git"
    else if type == "symlink" then builtins.match "^result(|-.*)$" basename == null
    else builtins.match "^((|\..*)\.sw[a-z]|.*~)$" basename == null;

  nixpkgs = builtins.filterSource filterFn pkgs.path;

  channelSources = pkgs.runCommand "nixos-${config.system.nixosVersion}" {} ''
    mkdir -p $out
    cp -prd ${nixpkgs} $out/nixos
    chmod -R u+w $out/nixos
    if [ ! -e $out/nixos/nixpkgs ]; then
      ln -s . $out/nixos/nixpkgs
    fi
    rm -rf $out/nixos/.git
    echo -n ${config.system.nixosVersionSuffix} > $out/nixos/.version-suffix
  '';

  metaClosure = pkgs.writeText "meta" ''
    ${config.system.build.toplevel}
    ${config.nix.package.out}
    ${channelSources}
  '';

  prepareImageInputs = with pkgs; [ rsync utillinux parted e2fsprogs lkl fakeroot config.system.build.nixos-prepare-root ] ++ stdenv.initialPath;

  # I'm preserving the line below because I'm going to search for it across nixpkgs to consolidate
  # image building logic. The comment right below this now appears in 4 different places in nixpkgs :)
  # !!! should use XML.
  sources = map (x: x.source) contents;
  targets = map (x: x.target) contents;

  prepareImage = ''
    export PATH=${pkgs.lib.makeSearchPathOutput "bin" "bin" prepareImageInputs}

    mkdir $out
    diskImage=nixos.raw
    truncate -s ${toString diskSize}M $diskImage

    ${if partitioned then ''
      parted $diskImage -- mklabel msdos mkpart primary ext4 1M -1s
      offset=$((2048*512))
    '' else ''
      offset=0
    ''}

    mkfs.${fsType} -F -L nixos -E offset=$offset $diskImage
  
    root="$PWD/root"
    mkdir -p $root

    # Copy arbitrary other files into the image
    # Semi-shamelessly copied from make-etc.sh. I (@copumpkin) shall factor this stuff out as part of
    # https://github.com/NixOS/nixpkgs/issues/23052.
    set -f
    sources_=(${concatStringsSep " " sources})
    targets_=(${concatStringsSep " " targets})
    set +f

    for ((i = 0; i < ''${#targets_[@]}; i++)); do
      source="''${sources_[$i]}"
      target="''${targets_[$i]}"

      if [[ "$source" =~ '*' ]]; then
        # If the source name contains '*', perform globbing.
        mkdir -p $root/$target
        for fn in $source; do
          rsync -a --no-o --no-g "$fn" $root/$target/
        done
      else
        mkdir -p $root/$(dirname $target)
        if ! [ -e $root/$target ]; then
          rsync -a --no-o --no-g $source $root/$target
        else
          echo "duplicate entry $target -> $source"
          exit 1
        fi
      fi
    done

    # TODO: Nix really likes to chown things it creates to its current user...
    fakeroot nixos-prepare-root $root ${channelSources} ${config.system.build.toplevel} closure

    echo "copying staging root to image..."
    cptofs ${pkgs.lib.optionalString partitioned "-P 1"} -t ${fsType} -i $diskImage $root/* /
  '';
in pkgs.vmTools.runInLinuxVM (
  pkgs.runCommand name
    { preVM = prepareImage;
      buildInputs = with pkgs; [ utillinux e2fsprogs ];
      exportReferencesGraph = [ "closure" metaClosure ];
      postVM = ''
        ${if format == "raw" then ''
          mv $diskImage $out/nixos.img
          diskImage=$out/nixos.img
        '' else ''
          ${pkgs.qemu}/bin/qemu-img convert -f raw -O qcow2 $diskImage $out/nixos.qcow2
          diskImage=$out/nixos.qcow2
        ''}
        ${postVM}
      '';
      memSize = 1024;
    }
    ''
      ${if partitioned then ''
        . /sys/class/block/vda1/uevent
        mknod /dev/vda1 b $MAJOR $MINOR
        rootDisk=/dev/vda1
      '' else ''
        rootDisk=/dev/vda
      ''}

      # Some tools assume these exist
      ln -s vda /dev/xvda
      ln -s vda /dev/sda

      mountPoint=/mnt
      mkdir $mountPoint
      mount $rootDisk $mountPoint

      # Install a configuration.nix
      mkdir -p /mnt/etc/nixos
      ${optionalString (configFile != null) ''
        cp ${configFile} /mnt/etc/nixos/configuration.nix
      ''}

      mount --rbind /dev  $mountPoint/dev
      mount --rbind /proc $mountPoint/proc
      mount --rbind /sys  $mountPoint/sys

      # Set up core system link, GRUB, etc.
      NIXOS_INSTALL_BOOTLOADER=1 chroot $mountPoint /nix/var/nix/profiles/system/bin/switch-to-configuration boot

      # TODO: figure out if I should activate, but for now I won't
      # chroot $mountPoint /nix/var/nix/profiles/system/activate

      # The above scripts will generate a random machine-id and we don't want to bake a single ID into all our images
      rm -f $mountPoint/etc/machine-id

      umount -R /mnt

      # Make sure resize2fs works. Note that resize2fs has stricter criteria for resizing than a normal
      # mount, so the `-c 0` and `-i 0` don't affect it. Setting it to `now` doesn't produce deterministic
      # output, of course, but we can fix that when/if we start making images deterministic.
      ${optionalString (fsType == "ext4") ''
        tune2fs -T now -c 0 -i 0 $rootDisk
      ''}
    ''
)
