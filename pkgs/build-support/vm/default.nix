{
  lib,
  pkgs,
  customQemu ? null,
  kernel ? pkgs.linux,
  img ? pkgs.stdenv.hostPlatform.linux-kernel.target,
  storeDir ? builtins.storeDir,
  rootModules ? [
    "virtio_pci"
    "virtio_mmio"
    "virtio_blk"
    "virtio_balloon"
    "virtio_rng"
    "ext4"
    "virtiofs"
    "crc32c_generic"
  ],
}:

let
  inherit (pkgs)
    bash
    bashInteractive
    busybox
    cpio
    coreutils
    e2fsprogs
    fetchurl
    kmod
    rpm
    stdenv
    util-linux
    buildPackages
    writeScript
    writeText
    runCommand
    ;
in
rec {
  qemu-common = import ../../../nixos/lib/qemu-common.nix { inherit lib pkgs; };

  qemu = buildPackages.qemu_kvm;

  modulesClosure = pkgs.makeModulesClosure {
    kernel = lib.getOutput "modules" kernel;
    inherit rootModules;
    firmware = kernel;
  };

  hd = "vda"; # either "sda" or "vda"

  initrdUtils =
    runCommand "initrd-utils"
      {
        nativeBuildInputs = [ buildPackages.nukeReferences ];
        allowedReferences = [
          "out"
          modulesClosure
        ]; # prevent accidents like glibc being included in the initrd
      }
      ''
        mkdir -p $out/bin
        mkdir -p $out/lib

        # Copy what we need from Glibc.
        cp -p \
          ${pkgs.stdenv.cc.libc}/lib/ld-*.so.? \
          ${pkgs.stdenv.cc.libc}/lib/libc.so.* \
          ${pkgs.stdenv.cc.libc}/lib/libm.so.* \
          ${pkgs.stdenv.cc.libc}/lib/libresolv.so.* \
          ${pkgs.stdenv.cc.libc}/lib/libpthread.so.* \
          ${pkgs.zstd.out}/lib/libzstd.so.* \
          ${pkgs.xz.out}/lib/liblzma.so.* \
          $out/lib

        # Copy BusyBox.
        cp -pd ${pkgs.busybox}/bin/* $out/bin
        cp -pd ${pkgs.kmod}/bin/* $out/bin

        # Run patchelf to make the programs refer to the copied libraries.
        for i in $out/bin/* $out/lib/*; do if ! test -L $i; then nuke-refs $i; fi; done

        for i in $out/bin/*; do
            if [ -f "$i" -a ! -L "$i" ]; then
                echo "patching $i..."
                patchelf --set-interpreter $out/lib/ld-*.so.? --set-rpath $out/lib $i || true
            fi
        done

        find $out/lib -type f \! -name 'ld*.so.?' | while read i; do
          echo "patching $i..."
          patchelf --set-rpath $out/lib $i
        done
      ''; # */

  stage1Init = writeScript "vm-run-stage1" ''
    #! ${initrdUtils}/bin/ash -e

    export PATH=${initrdUtils}/bin

    mkdir /etc
    echo -n > /etc/fstab

    mount -t proc none /proc
    mount -t sysfs none /sys

    echo 2 > /proc/sys/vm/panic_on_oom

    for o in $(cat /proc/cmdline); do
      case $o in
        mountDisk=*)
          mountDisk=''${mountDisk#mountDisk=}
          ;;
        command=*)
          set -- $(IFS==; echo $o)
          command=$2
          ;;
      esac
    done

    echo "loading kernel modules..."
    for i in $(cat ${modulesClosure}/insmod-list); do
      insmod $i || echo "warning: unable to load $i"
    done

    mount -t devtmpfs devtmpfs /dev
    ln -s /proc/self/fd /dev/fd
    ln -s /proc/self/fd/0 /dev/stdin
    ln -s /proc/self/fd/1 /dev/stdout
    ln -s /proc/self/fd/2 /dev/stderr

    ifconfig lo up

    mkdir /fs

    if test -z "$mountDisk"; then
      mount -t tmpfs none /fs
    elif [[ -e "$mountDisk" ]]; then
      mount "$mountDisk" /fs
    else
      mount /dev/${hd} /fs
    fi

    mkdir -p /fs/dev
    mount -o bind /dev /fs/dev

    mkdir -p /fs/dev/shm /fs/dev/pts
    mount -t tmpfs -o "mode=1777" none /fs/dev/shm
    mount -t devpts none /fs/dev/pts

    echo "mounting Nix store..."
    mkdir -p /fs${storeDir}
    mount -t virtiofs store /fs${storeDir}

    mkdir -p /fs/tmp /fs/run /fs/var
    mount -t tmpfs -o "mode=1777" none /fs/tmp
    mount -t tmpfs -o "mode=755" none /fs/run
    ln -sfn /run /fs/var/run

    echo "mounting host's temporary directory..."
    mkdir -p /fs/tmp/xchg
    mount -t virtiofs xchg /fs/tmp/xchg

    mkdir -p /fs/proc
    mount -t proc none /fs/proc

    mkdir -p /fs/sys
    mount -t sysfs none /fs/sys

    mkdir -p /fs/etc
    ln -sf /proc/mounts /fs/etc/mtab
    echo "127.0.0.1 localhost" > /fs/etc/hosts
    # Ensures tools requiring /etc/passwd will work (e.g. nix)
    if [ ! -e /fs/etc/passwd ]; then
      echo "root:x:0:0:System administrator:/root:/bin/sh" > /fs/etc/passwd
    fi

    echo "starting stage 2 ($command)"
    exec switch_root /fs $command
  '';

  initrd = pkgs.makeInitrd {
    contents = [
      {
        object = stage1Init;
        symlink = "/init";
      }
    ];
  };

  stage2Init = writeScript "vm-run-stage2" ''
    #! ${bash}/bin/sh
    set -euo pipefail
    source /tmp/xchg/saved-env
    if [ -f /tmp/xchg/.attrs.sh ]; then
      source /tmp/xchg/.attrs.sh
      export NIX_ATTRS_JSON_FILE=/tmp/xchg/.attrs.json
      export NIX_ATTRS_SH_FILE=/tmp/xchg/.attrs.sh
    fi

    export NIX_STORE=${storeDir}
    export NIX_BUILD_TOP=/tmp
    export TMPDIR=/tmp
    export PATH=/empty
    cd "$NIX_BUILD_TOP"

    source $stdenv/setup

    if ! test -e /bin/sh; then
      ${coreutils}/bin/mkdir -p /bin
      ${coreutils}/bin/ln -s ${bash}/bin/sh /bin/sh
    fi

    # Set up automatic kernel module loading.
    export MODULE_DIR=${lib.getOutput "modules" kernel}/lib/modules/
    ${coreutils}/bin/cat <<EOF > /run/modprobe
    #! ${bash}/bin/sh
    export MODULE_DIR=$MODULE_DIR
    exec ${kmod}/bin/modprobe "\$@"
    EOF
    ${coreutils}/bin/chmod 755 /run/modprobe
    echo /run/modprobe > /proc/sys/kernel/modprobe

    # For debugging: if this is the second time this image is run,
    # then don't start the build again, but instead drop the user into
    # an interactive shell.
    if test -n "$origBuilder" -a ! -e /.debug; then
      exec < /dev/null
      ${coreutils}/bin/touch /.debug
      declare -a argsArray=()
      concatTo argsArray origArgs
      "$origBuilder" "''${argsArray[@]}"
      echo $? > /tmp/xchg/in-vm-exit

      ${busybox}/bin/mount -o remount,ro dummy /

      ${busybox}/bin/poweroff -f
    else
      export PATH=/bin:/usr/bin:${coreutils}/bin
      echo "Starting interactive shell..."
      echo "(To run the original builder: \$origBuilder \$origArgs)"
      exec ${busybox}/bin/setsid ${bashInteractive}/bin/bash < /dev/${qemu-common.qemuSerialDevice} &> /dev/${qemu-common.qemuSerialDevice}
    fi
  '';

  qemuCommandLinux = ''
    ${if (customQemu != null) then customQemu else (qemu-common.qemuBinary qemu)} \
      -nographic -no-reboot \
      -device virtio-rng-pci \
      -chardev socket,id=store,path=virtio-store.sock \
      -device vhost-user-fs-pci,chardev=store,tag=store \
      -chardev socket,id=xchg,path=virtio-xchg.sock \
      -device vhost-user-fs-pci,chardev=xchg,tag=xchg \
      ''${diskImage:+-drive file=$diskImage,if=virtio,cache=unsafe,werror=report} \
      -kernel ${kernel}/${img} \
      -initrd ${initrd}/initrd \
      -append "console=${qemu-common.qemuSerialDevice} panic=1 command=${stage2Init} mountDisk=$mountDisk loglevel=4" \
      $QEMU_OPTS
  '';

  vmRunCommand =
    qemuCommand:
    writeText "vm-run" ''
      ${coreutils}/bin/mkdir xchg
      export > xchg/saved-env

      if [ -f "''${NIX_ATTRS_SH_FILE-}" ]; then
        ${coreutils}/bin/cp $NIX_ATTRS_JSON_FILE $NIX_ATTRS_SH_FILE xchg
        source "$NIX_ATTRS_SH_FILE"
      fi
      source $stdenv/setup

      eval "$preVM"

      if [ "$enableParallelBuilding" = 1 ]; then
        QEMU_NR_VCPUS=0
        if [ ''${NIX_BUILD_CORES:-0} = 0 ]; then
          QEMU_NR_VCPUS="$(nproc)"
        else
          QEMU_NR_VCPUS="$NIX_BUILD_CORES"
        fi
        # qemu only supports 255 vCPUs (see error from `qemu-system-x86_64 -smp 256`)
        if [ "$QEMU_NR_VCPUS" -gt 255 ]; then
          QEMU_NR_VCPUS=255
        fi
        QEMU_OPTS+=" -smp cpus=$QEMU_NR_VCPUS"
      fi

      # Write the command to start the VM to a file so that the user can
      # debug inside the VM if the build fails (when Nix is called with
      # the -K option to preserve the temporary build directory).
      ${coreutils}/bin/cat > ./run-vm <<EOF
      #! ${bash}/bin/sh
      ''${diskImage:+diskImage=$diskImage}
      # GitHub Actions runners seems to not allow installing seccomp filter: https://github.com/rcambrj/nix-pi-loader/issues/1#issuecomment-2605497516
      # Since we are running in a sandbox already, the difference between seccomp and none is minimal
      ${pkgs.virtiofsd}/bin/virtiofsd --xattr --socket-path virtio-store.sock --sandbox none --seccomp none --shared-dir "${storeDir}" &
      ${pkgs.virtiofsd}/bin/virtiofsd --xattr --socket-path virtio-xchg.sock --sandbox none --seccomp none --shared-dir xchg &
      ${qemuCommand}
      EOF

      ${coreutils}/bin/chmod +x ./run-vm
      source ./run-vm

      if ! test -e xchg/in-vm-exit; then
        echo "Virtual machine didn't produce an exit code."
        exit 1
      fi

      exitCode="$(${coreutils}/bin/cat xchg/in-vm-exit)"
      if [ "$exitCode" != "0" ]; then
        exit "$exitCode"
      fi

      eval "$postVM"
    '';

  # A bash script fragment that produces a disk image at `destination`.
  createEmptyImage =
    {
      # Disk image size in MiB (1024*1024 bytes)
      size,
      # Name that will be written to ${destination}/nix-support/full-name
      fullName,
      # Where to write the image files, defaulting to $out
      destination ? "$out",
    }:
    ''
      mkdir -p ${destination}
      diskImage=${destination}/disk-image.qcow2
      ${qemu}/bin/qemu-img create -f qcow2 $diskImage "${toString size}M"

      mkdir ${destination}/nix-support
      echo "${fullName}" > ${destination}/nix-support/full-name
    '';

  defaultCreateRootFS = ''
    mkdir /mnt
    ${e2fsprogs}/bin/mkfs.ext4 /dev/${hd}
    ${util-linux}/bin/mount -t ext4 /dev/${hd} /mnt

    if test -e /mnt/.debug; then
      exec ${bash}/bin/sh
    fi
    touch /mnt/.debug

    mkdir /mnt/proc /mnt/dev /mnt/sys
  '';

  /*
    Run a derivation in a Linux virtual machine (using Qemu/KVM).  By
    default, there is no disk image; the root filesystem is a tmpfs,
    and the nix store is shared with the host (via the 9P protocol).
    Thus, any pure Nix derivation should run unmodified, e.g. the
    call

      runInLinuxVM patchelf

    will build the derivation `patchelf' inside a VM.  The attribute
    `preVM' can optionally contain a shell command to be evaluated
    *before* the VM is started (i.e., on the host).  The attribute
    `memSize' specifies the memory size of the VM in MiB (1024*1024
    bytes), defaulting to 512.  The attribute `diskImage' can
    optionally specify a file system image to be attached to /dev/sda.
    (Note that currently we expect the image to contain a filesystem,
    not a full disk image with a partition table etc.)

    If the build fails and Nix is run with the `-K' option, a script
    `run-vm' will be left behind in the temporary build directory
    that allows you to boot into the VM and debug it interactively.
  */

  runInLinuxVM =
    drv:
    lib.overrideDerivation drv (
      {
        memSize ? 512,
        QEMU_OPTS ? "",
        args,
        builder,
        ...
      }:
      {
        requiredSystemFeatures = [ "kvm" ];
        builder = "${bash}/bin/sh";
        args = [
          "-e"
          (vmRunCommand qemuCommandLinux)
        ];
        origArgs = args;
        origBuilder = builder;
        QEMU_OPTS = "${QEMU_OPTS} -m ${toString memSize} -object memory-backend-memfd,id=mem,size=${toString memSize}M,share=on -machine memory-backend=mem";
        passAsFile = [ ]; # HACK fix - see https://github.com/NixOS/nixpkgs/issues/16742
      }
    );

  extractFs =
    {
      file,
      fs ? null,
    }:
    runInLinuxVM (
      stdenv.mkDerivation {
        name = "extract-file";
        buildInputs = [ util-linux ];
        buildCommand = ''
          ln -s ${kernel}/lib /lib
          ${kmod}/bin/modprobe loop
          ${kmod}/bin/modprobe ext4
          ${kmod}/bin/modprobe hfs
          ${kmod}/bin/modprobe hfsplus
          ${kmod}/bin/modprobe squashfs
          ${kmod}/bin/modprobe iso9660
          ${kmod}/bin/modprobe ufs
          ${kmod}/bin/modprobe cramfs

          mkdir -p $out
          mkdir -p tmp
          mount -o loop,ro,ufstype=44bsd ${lib.optionalString (fs != null) "-t ${fs} "}${file} tmp ||
            mount -o loop,ro ${lib.optionalString (fs != null) "-t ${fs} "}${file} tmp
          cp -Rv tmp/* $out/ || exit 0
        '';
      }
    );

  extractMTDfs =
    {
      file,
      fs ? null,
    }:
    runInLinuxVM (
      stdenv.mkDerivation {
        name = "extract-file-mtd";
        buildInputs = [
          pkgs.util-linux
          pkgs.mtdutils
        ];
        buildCommand = ''
          ln -s ${kernel}/lib /lib
          ${kmod}/bin/modprobe mtd
          ${kmod}/bin/modprobe mtdram total_size=131072
          ${kmod}/bin/modprobe mtdchar
          ${kmod}/bin/modprobe mtdblock
          ${kmod}/bin/modprobe jffs2
          ${kmod}/bin/modprobe zlib

          mkdir -p $out
          mkdir -p tmp

          dd if=${file} of=/dev/mtd0
          mount ${lib.optionalString (fs != null) "-t ${fs} "}/dev/mtdblock0 tmp

          cp -R tmp/* $out/
        '';
      }
    );

  /*
    Like runInLinuxVM, but run the build not using the stdenv from
    the Nix store, but using the tools provided by /bin, /usr/bin
    etc. from the specified filesystem image, which typically is a
    filesystem containing a non-NixOS Linux distribution.
  */

  runInLinuxImage =
    drv:
    runInLinuxVM (
      lib.overrideDerivation drv (attrs: {
        mountDisk = attrs.mountDisk or true;

        /*
          Mount `image' as the root FS, but use a temporary copy-on-write
          image since we don't want to (and can't) write to `image'.
        */
        preVM = ''
          diskImage=$(pwd)/disk-image.qcow2
          origImage=${attrs.diskImage}
          if test -d "$origImage"; then origImage="$origImage/disk-image.qcow2"; fi
          ${qemu}/bin/qemu-img create -F ${attrs.diskImageFormat} -b "$origImage" -f qcow2 $diskImage
        '';

        /*
          Inside the VM, run the stdenv setup script normally, but at the
          very end set $PATH and $SHELL to the `native' paths for the
          distribution inside the VM.
        */
        postHook = ''
          PATH=/usr/bin:/bin:/usr/sbin:/sbin
          SHELL=/bin/sh
          eval "$origPostHook"
        '';

        origPostHook = lib.optionalString (attrs ? postHook) attrs.postHook;

        # Don't run Nix-specific build steps like patchelf.
        fixupPhase = "true";
      })
    );

  /*
    Create a filesystem image of the specified size and fill it with
    a set of RPM packages.
  */

  fillDiskWithRPMs =
    {
      size ? 4096,
      rpms,
      name,
      fullName,
      preInstall ? "",
      postInstall ? "",
      runScripts ? true,
      createRootFS ? defaultCreateRootFS,
      QEMU_OPTS ? "",
      memSize ? 512,
      unifiedSystemDir ? false,
    }:

    runInLinuxVM (
      stdenv.mkDerivation {
        inherit
          name
          preInstall
          postInstall
          rpms
          QEMU_OPTS
          memSize
          ;
        preVM = createEmptyImage { inherit size fullName; };

        buildCommand = ''
          ${createRootFS}

          chroot=$(type -tP chroot)

          # Make the Nix store available in /mnt, because that's where the RPMs live.
          mkdir -p /mnt${storeDir}
          ${util-linux}/bin/mount -o bind ${storeDir} /mnt${storeDir}
          # Some programs may require devices in /dev to be available (e.g. /dev/random)
          ${util-linux}/bin/mount -o bind /dev /mnt/dev

          # Newer distributions like Fedora 18 require /lib etc. to be
          # symlinked to /usr.
          ${lib.optionalString unifiedSystemDir ''
            mkdir -p /mnt/usr/bin /mnt/usr/sbin /mnt/usr/lib /mnt/usr/lib64
            ln -s /usr/bin /mnt/bin
            ln -s /usr/sbin /mnt/sbin
            ln -s /usr/lib /mnt/lib
            ln -s /usr/lib64 /mnt/lib64
            ${util-linux}/bin/mount -t proc none /mnt/proc
          ''}

          echo "unpacking RPMs..."
          set +o pipefail
          for i in $rpms; do
              echo "$i..."
              ${rpm}/bin/rpm2cpio "$i" | chroot /mnt ${cpio}/bin/cpio -i --make-directories --unconditional
          done

          eval "$preInstall"

          echo "initialising RPM DB..."
          PATH=/usr/bin:/bin:/usr/sbin:/sbin $chroot /mnt \
            ldconfig -v || true
          PATH=/usr/bin:/bin:/usr/sbin:/sbin $chroot /mnt \
            rpm --initdb

          ${util-linux}/bin/mount -o bind /tmp /mnt/tmp

          echo "installing RPMs..."
          PATH=/usr/bin:/bin:/usr/sbin:/sbin $chroot /mnt \
            rpm -iv --nosignature ${lib.optionalString (!runScripts) "--noscripts"} $rpms

          echo "running post-install script..."
          eval "$postInstall"

          rm /mnt/.debug

          ${util-linux}/bin/umount /mnt${storeDir} /mnt/tmp /mnt/dev ${lib.optionalString unifiedSystemDir "/mnt/proc"}
          ${util-linux}/bin/umount /mnt
        '';

        passthru = { inherit fullName; };
      }
    );

  /*
    Generate a script that can be used to run an interactive session
    in the given image.
  */

  makeImageTestScript =
    image:
    writeScript "image-test" ''
      #! ${bash}/bin/sh
      if test -z "$1"; then
        echo "Syntax: $0 <copy-on-write-temp-file>"
        exit 1
      fi
      diskImage="$1"
      if ! test -e "$diskImage"; then
        ${qemu}/bin/qemu-img create -b ${image}/disk-image.qcow2 -f qcow2 -F qcow2 "$diskImage"
      fi
      export TMPDIR=$(mktemp -d)
      export out=/dummy
      export origBuilder=
      export origArgs=
      mkdir $TMPDIR/xchg
      export > $TMPDIR/xchg/saved-env
      mountDisk=1
      ${qemuCommandLinux}
    '';

  /*
    Build RPM packages from the tarball `src' in the Linux
    distribution installed in the filesystem `diskImage'.  The
    tarball must contain an RPM specfile.
  */

  buildRPM =
    attrs:
    runInLinuxImage (
      stdenv.mkDerivation (
        {
          prePhases = [
            "prepareImagePhase"
            "sysInfoPhase"
          ];
          dontConfigure = true;

          outDir = "rpms/${attrs.diskImage.name}";

          prepareImagePhase = ''
            if test -n "$extraRPMs"; then
              for rpmdir in $extraRPMs ; do
                rpm -iv $(ls $rpmdir/rpms/*/*.rpm | grep -v 'src\.rpm' | sort | head -1)
              done
            fi
          '';

          sysInfoPhase = ''
            echo "System/kernel: $(uname -a)"
            if test -e /etc/fedora-release; then echo "Fedora release: $(cat /etc/fedora-release)"; fi
            if test -e /etc/SuSE-release; then echo "SUSE release: $(cat /etc/SuSE-release)"; fi
            echo "installed RPM packages"
            rpm -qa --qf "%{Name}-%{Version}-%{Release} (%{Arch}; %{Distribution}; %{Vendor})\n"
          '';

          buildPhase = ''
            eval "$preBuild"

            srcName="$(rpmspec --srpm -q --qf '%{source}' *.spec)"
            cp "$src" "$srcName" # `ln' doesn't work always work: RPM requires that the file is owned by root

            export HOME=/tmp/home
            mkdir $HOME

            rpmout=/tmp/rpmout
            mkdir $rpmout $rpmout/SPECS $rpmout/BUILD $rpmout/RPMS $rpmout/SRPMS

            echo "%_topdir $rpmout" >> $HOME/.rpmmacros

            if [ `uname -m` = i686 ]; then extra="--target i686-linux"; fi
            rpmbuild -vv $extra -ta "$srcName"

            eval "$postBuild"
          '';

          installPhase = ''
            eval "$preInstall"

            mkdir -p $out/$outDir
            find $rpmout -name "*.rpm" -exec cp {} $out/$outDir \;

            for i in $out/$outDir/*.rpm; do
              echo "Generated RPM/SRPM: $i"
              rpm -qip $i
            done

            eval "$postInstall"
          ''; # */
        }
        // attrs
      )
    );

  /*
    Create a filesystem image of the specified size and fill it with
    a set of Debian packages.  `debs' must be a list of list of
    .deb files, namely, the Debian packages grouped together into
    strongly connected components.  See deb/deb-closure.nix.
  */

  fillDiskWithDebs =
    {
      size ? 4096,
      debs,
      name,
      fullName,
      postInstall ? null,
      createRootFS ? defaultCreateRootFS,
      QEMU_OPTS ? "",
      memSize ? 512,
      ...
    }@args:

    runInLinuxVM (
      stdenv.mkDerivation (
        {
          inherit
            name
            postInstall
            QEMU_OPTS
            memSize
            ;

          debs = (lib.intersperse "|" debs);

          preVM = createEmptyImage { inherit size fullName; };

          buildCommand = ''
            ${createRootFS}

            PATH=$PATH:${
              lib.makeBinPath [
                pkgs.dpkg
                pkgs.glibc
                pkgs.xz
              ]
            }

            # Unpack the .debs.  We do this to prevent pre-install scripts
            # (which have lots of circular dependencies) from barfing.
            echo "unpacking Debs..."

            for deb in $debs; do
              if test "$deb" != "|"; then
                echo "$deb..."
                dpkg-deb --extract "$deb" /mnt
              fi
            done

            # Make the Nix store available in /mnt, because that's where the .debs live.
            mkdir -p /mnt/inst${storeDir}
            ${util-linux}/bin/mount -o bind ${storeDir} /mnt/inst${storeDir}
            ${util-linux}/bin/mount -o bind /proc /mnt/proc
            ${util-linux}/bin/mount -o bind /dev /mnt/dev

            # Misc. files/directories assumed by various packages.
            echo "initialising Dpkg DB..."
            touch /mnt/etc/shells
            touch /mnt/var/lib/dpkg/status
            touch /mnt/var/lib/dpkg/available
            touch /mnt/var/lib/dpkg/diversions

            # Now install the .debs.  This is basically just to register
            # them with dpkg and to make their pre/post-install scripts
            # run.
            echo "installing Debs..."

            export DEBIAN_FRONTEND=noninteractive

            oldIFS="$IFS"
            IFS="|"
            for component in $debs; do
              IFS="$oldIFS"
              echo
              echo ">>> INSTALLING COMPONENT: $component"
              debs=
              for i in $component; do
                debs="$debs /inst/$i";
              done
              chroot=$(type -tP chroot)

              # Create a fake start-stop-daemon script, as done in debootstrap.
              mv "/mnt/sbin/start-stop-daemon" "/mnt/sbin/start-stop-daemon.REAL"
              echo "#!/bin/true" > "/mnt/sbin/start-stop-daemon"
              chmod 755 "/mnt/sbin/start-stop-daemon"

              PATH=/usr/bin:/bin:/usr/sbin:/sbin $chroot /mnt \
                /usr/bin/dpkg --install --force-all $debs < /dev/null || true

              # Move the real start-stop-daemon back into its place.
              mv "/mnt/sbin/start-stop-daemon.REAL" "/mnt/sbin/start-stop-daemon"
            done

            echo "running post-install script..."
            eval "$postInstall"

            rm /mnt/.debug

            ${util-linux}/bin/umount /mnt/inst${storeDir}
            ${util-linux}/bin/umount /mnt/proc
            ${util-linux}/bin/umount /mnt/dev
            ${util-linux}/bin/umount /mnt
          '';

          passthru = { inherit fullName; };
        }
        // args
      )
    );

  /*
    Generate a Nix expression containing fetchurl calls for the
    closure of a set of top-level RPM packages from the
    `primary.xml.gz' file of a Fedora or openSUSE distribution.
  */

  rpmClosureGenerator =
    {
      name,
      packagesLists,
      urlPrefixes,
      packages,
      archs ? [ ],
    }:
    assert (builtins.length packagesLists) == (builtins.length urlPrefixes);
    runCommand "${name}.nix"
      {
        nativeBuildInputs = [
          buildPackages.perl
          buildPackages.perlPackages.XMLSimple
        ];
        inherit archs;
      }
      ''
        ${lib.concatImapStrings (i: pl: ''
          gunzip < ${pl} > ./packages_${toString i}.xml
        '') packagesLists}
        perl -w ${rpm/rpm-closure.pl} \
          ${
            lib.concatImapStrings (i: pl: "./packages_${toString i}.xml ${pl.snd} ") (
              lib.zipLists packagesLists urlPrefixes
            )
          } \
          ${toString packages} > $out
      '';

  /*
    Helper function that combines rpmClosureGenerator and
    fillDiskWithRPMs to generate a disk image from a set of package
    names.
  */

  makeImageFromRPMDist =
    {
      name,
      fullName,
      size ? 4096,
      urlPrefix ? "",
      urlPrefixes ? [ urlPrefix ],
      packagesList ? "",
      packagesLists ? [ packagesList ],
      packages,
      extraPackages ? [ ],
      preInstall ? "",
      postInstall ? "",
      archs ? [
        "noarch"
        "i386"
      ],
      runScripts ? true,
      createRootFS ? defaultCreateRootFS,
      QEMU_OPTS ? "",
      memSize ? 512,
      unifiedSystemDir ? false,
    }:

    fillDiskWithRPMs {
      inherit
        name
        fullName
        size
        preInstall
        postInstall
        runScripts
        createRootFS
        unifiedSystemDir
        QEMU_OPTS
        memSize
        ;
      rpms = import (rpmClosureGenerator {
        inherit
          name
          packagesLists
          urlPrefixes
          archs
          ;
        packages = packages ++ extraPackages;
      }) { inherit fetchurl; };
    };

  /*
    Like `rpmClosureGenerator', but now for Debian/Ubuntu releases
    (i.e. generate a closure from a Packages.bz2 file).
  */

  debClosureGenerator =
    {
      name,
      packagesLists,
      urlPrefix,
      packages,
    }:

    runCommand "${name}.nix"
      {
        nativeBuildInputs = [
          buildPackages.perl
          buildPackages.dpkg
          buildPackages.nixfmt
        ];
      }
      ''
        for i in ${toString packagesLists}; do
          echo "adding $i..."
          case $i in
            *.xz | *.lzma)
              xz -d < $i >> ./Packages
              ;;
            *.bz2)
              bunzip2 < $i >> ./Packages
              ;;
            *.gz)
              gzip -dc < $i >> ./Packages
              ;;
          esac
        done

        perl -w ${deb/deb-closure.pl} \
          ./Packages ${urlPrefix} ${toString packages} > $out
        nixfmt $out
      '';

  /*
    Helper function that combines debClosureGenerator and
    fillDiskWithDebs to generate a disk image from a set of package
    names.
  */

  makeImageFromDebDist =
    {
      name,
      fullName,
      size ? 4096,
      urlPrefix,
      packagesList ? "",
      packagesLists ? [ packagesList ],
      packages,
      extraPackages ? [ ],
      postInstall ? "",
      extraDebs ? [ ],
      createRootFS ? defaultCreateRootFS,
      QEMU_OPTS ? "",
      memSize ? 512,
      ...
    }@args:

    let
      expr = debClosureGenerator {
        inherit name packagesLists urlPrefix;
        packages = packages ++ extraPackages;
      };
    in
    (fillDiskWithDebs (
      {
        inherit
          name
          fullName
          size
          postInstall
          createRootFS
          QEMU_OPTS
          memSize
          ;
        debs = import expr { inherit fetchurl; } ++ extraDebs;
      }
      // args
    ))
    // {
      inherit expr;
    };

  # The set of supported RPM-based distributions.

  rpmDistros = { };

  # The set of supported Dpkg-based distributions.

  debDistros = {
    ubuntu2204i386 = {
      name = "ubuntu-22.04-jammy-i386";
      fullName = "Ubuntu 22.04 Jammy (i386)";
      packagesLists = [
        (fetchurl {
          url = "mirror://ubuntu/dists/jammy/main/binary-i386/Packages.xz";
          sha256 = "sha256-iZBmwT0ep4v+V3sayybbOgZBOFFZwPGpOKtmuLMMVPQ=";
        })
        (fetchurl {
          url = "mirror://ubuntu/dists/jammy/universe/binary-i386/Packages.xz";
          sha256 = "sha256-DO2LdpZ9rDDBhWj2gvDWd0TJJVZHxKsYTKTi6GXjm1E=";
        })
      ];
      urlPrefix = "mirror://ubuntu";
      packages = commonDebPackages ++ [
        "diffutils"
        "libc-bin"
      ];
    };

    ubuntu2204x86_64 = {
      name = "ubuntu-22.04-jammy-amd64";
      fullName = "Ubuntu 22.04 Jammy (amd64)";
      packagesLists = [
        (fetchurl {
          url = "mirror://ubuntu/dists/jammy/main/binary-amd64/Packages.xz";
          sha256 = "sha256-N8tX8VVMv6ccWinun/7hipqMF4K7BWjgh0t/9M6PnBE=";
        })
        (fetchurl {
          url = "mirror://ubuntu/dists/jammy/universe/binary-amd64/Packages.xz";
          sha256 = "sha256-0pyyTJP+xfQyVXBrzn60bUd5lSA52MaKwbsUpvNlXOI=";
        })
      ];
      urlPrefix = "mirror://ubuntu";
      packages = commonDebPackages ++ [
        "diffutils"
        "libc-bin"
      ];
    };

    ubuntu2404x86_64 = {
      name = "ubuntu-24.04-noble-amd64";
      fullName = "Ubuntu 24.04 Noble (amd64)";
      packagesLists = [
        (fetchurl {
          url = "mirror://ubuntu/dists/noble/main/binary-amd64/Packages.xz";
          sha256 = "sha256-KmoZnhAxpcJ5yzRmRtWUmT81scA91KgqqgMjmA3ZJFE=";
        })
        (fetchurl {
          url = "mirror://ubuntu/dists/noble/universe/binary-amd64/Packages.xz";
          sha256 = "sha256-upBX+huRQ4zIodJoCNAMhTif4QHQwUliVN+XI2QFWZo=";
        })
      ];
      urlPrefix = "mirror://ubuntu";
      packages = commonDebPackages ++ [
        "diffutils"
        "libc-bin"
      ];
    };

    debian11i386 = {
      name = "debian-11.8-bullseye-i386";
      fullName = "Debian 11.8 Bullseye (i386)";
      packagesList = fetchurl {
        url = "https://snapshot.debian.org/archive/debian/20231124T031419Z/dists/bullseye/main/binary-i386/Packages.xz";
        hash = "sha256-0bKSLLPhEC7FB5D1NA2jaQP0wTe/Qp1ddiA/NDVjRaI=";
      };
      urlPrefix = "https://snapshot.debian.org/archive/debian/20231124T031419Z";
      packages = commonDebianPackages;
    };

    debian11x86_64 = {
      name = "debian-11.8-bullseye-amd64";
      fullName = "Debian 11.8 Bullseye (amd64)";
      packagesList = fetchurl {
        url = "https://snapshot.debian.org/archive/debian/20231124T031419Z/dists/bullseye/main/binary-amd64/Packages.xz";
        hash = "sha256-CYPsGgQgJZkh3JmbcAQkYDWP193qrkOADOgrMETZIeo=";
      };
      urlPrefix = "https://snapshot.debian.org/archive/debian/20231124T031419Z";
      packages = commonDebianPackages;
    };

    debian12i386 = {
      name = "debian-12.2-bookworm-i386";
      fullName = "Debian 12.2 Bookworm (i386)";
      packagesList = fetchurl {
        url = "https://snapshot.debian.org/archive/debian/20231124T031419Z/dists/bookworm/main/binary-i386/Packages.xz";
        hash = "sha256-OeN9Q2HFM3GsPNhOa4VhM7qpwT66yUNwC+6Z8SbGEeQ=";
      };
      urlPrefix = "https://snapshot.debian.org/archive/debian/20231124T031419Z";
      packages = commonDebianPackages;
    };

    debian12x86_64 = {
      name = "debian-12.2-bookworm-amd64";
      fullName = "Debian 12.2 Bookworm (amd64)";
      packagesList = fetchurl {
        url = "https://snapshot.debian.org/archive/debian/20231124T031419Z/dists/bookworm/main/binary-amd64/Packages.xz";
        hash = "sha256-SZDElRfe9BlBwDlajQB79Qdn08rv8whYoQDeVCveKVs=";
      };
      urlPrefix = "https://snapshot.debian.org/archive/debian/20231124T031419Z";
      packages = commonDebianPackages;
    };

    debian13i386 = {
      name = "debian-13.0-trixie-i386";
      fullName = "Debian 13.0 Trixie (i386)";
      packagesList = fetchurl {
        url = "https://snapshot.debian.org/archive/debian/20250819T202603Z/dists/trixie/main/binary-i386/Packages.xz";
        hash = "sha256-fXjhaG1Y+kn6iMEtqVZLwYN7lZ0cEQKVfMS3hSHJipY=";
      };
      urlPrefix = "https://snapshot.debian.org/archive/debian/20250819T202603Z";
      packages = commonDebianPackages;
    };

    debian13x86_64 = {
      name = "debian-13.0-trixie-amd64";
      fullName = "Debian 13.0 Trixie (amd64)";
      packagesList = fetchurl {
        url = "https://snapshot.debian.org/archive/debian/20250819T202603Z/dists/trixie/main/binary-amd64/Packages.xz";
        hash = "sha256-15cDoCcTv3m5fiZqP1hqWWnSG1BVUZSrm5YszTSKQs4=";
      };
      urlPrefix = "https://snapshot.debian.org/archive/debian/20250819T202603Z";
      packages = commonDebianPackages;
    };
  };

  # Common packages for Fedora images.
  commonFedoraPackages = [
    "autoconf"
    "automake"
    "basesystem"
    "bzip2"
    "curl"
    "diffutils"
    "fedora-release"
    "findutils"
    "gawk"
    "gcc-c++"
    "gzip"
    "make"
    "patch"
    "perl"
    "pkgconf-pkg-config"
    "rpm"
    "rpm-build"
    "tar"
    "unzip"
  ];

  commonCentOSPackages = [
    "autoconf"
    "automake"
    "basesystem"
    "bzip2"
    "curl"
    "diffutils"
    "centos-release"
    "findutils"
    "gawk"
    "gcc-c++"
    "gzip"
    "make"
    "patch"
    "perl"
    "pkgconfig"
    "rpm"
    "rpm-build"
    "tar"
    "unzip"
  ];

  commonRHELPackages = [
    "autoconf"
    "automake"
    "basesystem"
    "bzip2"
    "curl"
    "diffutils"
    "findutils"
    "gawk"
    "gcc-c++"
    "gzip"
    "make"
    "patch"
    "perl"
    "pkgconfig"
    "procps-ng"
    "rpm"
    "rpm-build"
    "tar"
    "unzip"
  ];

  # Common packages for openSUSE images.
  commonOpenSUSEPackages = [
    "aaa_base"
    "autoconf"
    "automake"
    "bzip2"
    "curl"
    "diffutils"
    "findutils"
    "gawk"
    "gcc-c++"
    "gzip"
    "make"
    "patch"
    "perl"
    "pkg-config"
    "rpm"
    "tar"
    "unzip"
    "util-linux"
    "gnu-getopt"
  ];

  # Common packages for Debian/Ubuntu images.
  commonDebPackages = [
    "base-passwd"
    "dpkg"
    "libc6-dev"
    "perl"
    "bash"
    "dash"
    "gzip"
    "bzip2"
    "tar"
    "grep"
    "mawk"
    "sed"
    "findutils"
    "g++"
    "make"
    "curl"
    "patch"
    "locales"
    "coreutils"
    # Needed by checkinstall:
    "util-linux"
    "file"
    "dpkg-dev"
    "pkg-config"
    # Needed because it provides /etc/login.defs, whose absence causes
    # the "passwd" post-installs script to fail.
    "login"
    "passwd"
  ];

  commonDebianPackages = commonDebPackages ++ [
    "sysvinit"
    "diff"
  ];

  /*
    A set of functions that build the Linux distributions specified
    in `rpmDistros' and `debDistros'.  For instance,
    `diskImageFuns.ubuntu1004x86_64 { }' builds an Ubuntu 10.04 disk
    image containing the default packages specified above.  Overrides
    of the default image parameters can be given.  In particular,
    `extraPackages' specifies the names of additional packages from
    the distribution that should be included in the image; `packages'
    allows the entire set of packages to be overridden; and `size'
    sets the size of the disk in MiB (1024*1024 bytes).  E.g.,
    `diskImageFuns.ubuntu1004x86_64 { extraPackages = ["firefox"];
    size = 8192; }' builds an 8 GiB image containing Firefox in
    addition to the default packages.
  */
  diskImageFuns =
    (lib.mapAttrs (
      name: as: as2:
      makeImageFromRPMDist (as // as2)
    ) rpmDistros)
    // (lib.mapAttrs (
      name: as: as2:
      makeImageFromDebDist (as // as2)
    ) debDistros);

  # Shorthand for `diskImageFuns.<attr> { extraPackages = ... }'.
  diskImageExtraFuns = lib.mapAttrs (
    name: f: extraPackages:
    f { inherit extraPackages; }
  ) diskImageFuns;

  /*
    Default disk images generated from the `rpmDistros' and
    `debDistros' sets.
  */
  diskImages = lib.mapAttrs (name: f: f { }) diskImageFuns;

}
