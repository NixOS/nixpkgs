{
  lib,
  stdenv,
  buildPackages,
  bash,
  bashInteractive,
  busybox,
  coreutils,
  cpio,
  dpkg,
  e2fsprogs,
  fetchurl,
  glibc,
  kmod,
  linux,
  makeInitrd,
  makeModulesClosure,
  mtdutils,
  rpm,
  runCommand,
  util-linux,
  virtiofsd,
  writeScript,
  writeText,
  xz,
  zstd,

  # ----------------------------
  # The following  arguments form the "interface" of `pkgs.vmTools`.
  # Note that `img` is a real package, but is set to this default in `all-packages.nix`.
  # ----------------------------
  customQemu ? null,
  kernel ? linux,
  img ? stdenv.hostPlatform.linux-kernel.target,
  storeDir ? builtins.storeDir,
  rootModules ? [
    "virtio_pci"
    "virtio_mmio"
    "virtio_blk"
    "virtio_balloon"
    "virtio_rng"
    "ext4"
    "virtiofs"
    "crc32c"
  ],
}:

let
  qemu-common = import ../../../nixos/lib/qemu-common.nix { inherit lib stdenv; };

  qemu = buildPackages.qemu_kvm;

  modulesClosure = makeModulesClosure {
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
          ${stdenv.cc.libc}/lib/ld-*.so.? \
          ${stdenv.cc.libc}/lib/libc.so.* \
          ${stdenv.cc.libc}/lib/libm.so.* \
          ${stdenv.cc.libc}/lib/libresolv.so.* \
          ${stdenv.cc.libc}/lib/libpthread.so.* \
          ${zstd.out}/lib/libzstd.so.* \
          ${xz.out}/lib/liblzma.so.* \
          $out/lib

        # Copy BusyBox.
        cp -pd ${busybox}/bin/* $out/bin
        cp -pd ${kmod}/bin/* $out/bin

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

  initrd = makeInitrd {
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
      ${virtiofsd}/bin/virtiofsd --xattr --socket-path virtio-store.sock --sandbox none --seccomp none --shared-dir "${storeDir}" &
      ${virtiofsd}/bin/virtiofsd --xattr --socket-path virtio-xchg.sock --sandbox none --seccomp none --shared-dir xchg &

      # Wait until virtiofsd has created these sockets to avoid race condition.
      until [[ -e virtio-store.sock ]]; do ${coreutils}/bin/sleep 1; done
      until [[ -e virtio-xchg.sock ]]; do ${coreutils}/bin/sleep 1; done

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
          util-linux
          mtdutils
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
            mkdir -p /mnt/usr/bin /mnt/usr/lib /mnt/usr/lib64
            ln -s /usr/bin /mnt/bin
            ln -s /usr/bin /mnt/sbin
            ln -s /usr/bin /mnt/usr/sbin
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
                dpkg
                glibc
                xz
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
          buildPackages.perlPackages.URI
          buildPackages.perlPackages.XMLSimple
          buildPackages.zstd
        ];
        inherit archs;
      }
      ''
        ${lib.concatImapStrings (i: pl: ''
          echo "decompressing ${pl}..."
          case ${pl} in
            *.zst)
              zstd -d < ${pl} > ./packages_${toString i}.xml
              ;;
            *.xz | *.lzma)
              xz -d < ${pl} > ./packages_${toString i}.xml
              ;;
            *.bz2)
              bunzip2 < ${pl} > ./packages_${toString i}.xml
              ;;
            *.gz)
              gunzip < ${pl} > ./packages_${toString i}.xml
              ;;
            *)
              cp ${pl} ./packages_${toString i}.xml
              ;;
          esac
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

  rpmDistros = {
    fedora42x86_64 = {
      name = "fedora-42-x86_64";
      fullName = "Fedora 42 (x86_64)";
      packagesList = fetchurl {
        url = "https://dl.fedoraproject.org/pub/fedora/linux/releases/42/Everything/x86_64/os/repodata/cd483b35df017d68b73a878a392bbf666a43d75db54c386e4720bc369eb5c3a3-primary.xml.zst";
        hash = "sha256-zUg7Nd8BfWi3OoeKOSu/ZmpD1121TDhuRyC8Np61w6M=";
      };
      urlPrefix = "https://dl.fedoraproject.org/pub/fedora/linux/releases/42/Everything/x86_64/os";
      archs = [
        "noarch"
        "x86_64"
      ];
      packages = commonFedoraPackages;
      unifiedSystemDir = true;
    };

    fedora43x86_64 = {
      name = "fedora-43-x86_64";
      fullName = "Fedora 43 (x86_64)";
      packagesList = fetchurl {
        url = "https://dl.fedoraproject.org/pub/fedora/linux/releases/43/Everything/x86_64/os/repodata/fffa3e9f63fffd3d21b8ea5e9bb0fe349a7ed1d4e09777a618cec93a2bcc305f-primary.xml.zst";
        hash = "sha256-//o+n2P//T0huOpem7D+NJp+0dTgl3emGM7JOivMMF8=";
      };
      urlPrefix = "https://dl.fedoraproject.org/pub/fedora/linux/releases/43/Everything/x86_64/os";
      archs = [
        "noarch"
        "x86_64"
      ];
      packages = commonFedoraPackages ++ [ "gpgverify" ];
      unifiedSystemDir = true;
    };

    # Rocky Linux's /pub/rocky/9/ URL is rolling and changes with each minor release. We use the
    # vault instead, which provides stable URLs for specific minor versions.
    rocky9x86_64 = {
      name = "rocky-9.6-x86_64";
      fullName = "Rocky Linux 9.6 (x86_64)";
      packagesLists = [
        (fetchurl {
          url = "https://dl.rockylinux.org/vault/rocky/9.6/BaseOS/x86_64/os/repodata/9965e429a90787a87a07eed62872d046411fb7dded524b96d74c4ce1eade327a-primary.xml.gz";
          hash = "sha256-mWXkKakHh6h6B+7WKHLQRkEft93tUkuW10xM4ereMno=";
        })
        (fetchurl {
          url = "https://dl.rockylinux.org/vault/rocky/9.6/AppStream/x86_64/os/repodata/8cc9f795679c3365c06b6135f685ebf4188a5863a5f52f09f8cabd4f09c4dfa1-primary.xml.gz";
          hash = "sha256-jMn3lWecM2XAa2E19oXr9BiKWGOl9S8J+Mq9TwnE36E=";
        })
      ];
      urlPrefixes = [
        "https://dl.rockylinux.org/vault/rocky/9.6/BaseOS/x86_64/os"
        "https://dl.rockylinux.org/vault/rocky/9.6/AppStream/x86_64/os"
      ];
      archs = [
        "noarch"
        "x86_64"
      ];
      packages = commonRockyPackages ++ [
        "annobin"
      ];
      unifiedSystemDir = true;
    };

    # Rocky Linux's /pub/rocky/10/ URL is rolling and changes with each minor release. We use the
    # vault instead, which provides stable URLs for specific minor versions.
    rocky10x86_64 = {
      name = "rocky-10.0-x86_64";
      fullName = "Rocky Linux 10.0 (x86_64)";
      packagesLists = [
        (fetchurl {
          url = "https://dl.rockylinux.org/vault/rocky/10.0/BaseOS/x86_64/os/repodata/484d5c43cdb1058dd1328a6b891f45c85f1cb2620c528f2ef423d4b9feb9e2f0-primary.xml.gz";
          hash = "sha256-SE1cQ82xBY3RMopriR9FyF8csmIMUo8u9CPUuf654vA=";
        })
        (fetchurl {
          url = "https://dl.rockylinux.org/vault/rocky/10.0/AppStream/x86_64/os/repodata/32c93064142d89f3f19c11e92642c5abd8368418f7ab3f3bdd752e4afa9b5b23-primary.xml.gz";
          hash = "sha256-MskwZBQtifPxnBHpJkLFq9g2hBj3qz873XUuSvqbWyM=";
        })
      ];
      urlPrefixes = [
        "https://dl.rockylinux.org/vault/rocky/10.0/BaseOS/x86_64/os"
        "https://dl.rockylinux.org/vault/rocky/10.0/AppStream/x86_64/os"
      ];
      archs = [
        "noarch"
        "x86_64"
      ];
      packages = commonRockyPackages ++ [
        "annobin-plugin-gcc"
      ];
      unifiedSystemDir = true;
    };

    # AlmaLinux's repo.almalinux.org URLs are rolling and change with each minor release.
    # We use vault.almalinux.org instead, which provides stable URLs for specific versions.
    alma9x86_64 = {
      name = "alma-9.6-x86_64";
      fullName = "AlmaLinux 9.6 (x86_64)";
      packagesLists = [
        (fetchurl {
          url = "https://vault.almalinux.org/9.6/BaseOS/x86_64/os/repodata/26d6cf944c86ef850773e61919e892a375ff10bb2254003e1d71673db9900b07-primary.xml.gz";
          hash = "sha256-JtbPlEyG74UHc+YZGeiSo3X/ELsiVAA+HXFnPbmQCwc=";
        })
        (fetchurl {
          url = "https://vault.almalinux.org/9.6/AppStream/x86_64/os/repodata/afb5d18b78d819d826d3d0e32ba439da7b9e0fd91d726dd833366496b1b8ca20-primary.xml.gz";
          hash = "sha256-r7XRi3jYGdgm09DjK6Q52nueD9kdcm3YMzZklrG4yiA=";
        })
      ];
      urlPrefixes = [
        "https://vault.almalinux.org/9.6/BaseOS/x86_64/os"
        "https://vault.almalinux.org/9.6/AppStream/x86_64/os"
      ];
      archs = [
        "noarch"
        "x86_64"
      ];
      packages = commonAlmaPackages ++ [
        "annobin"
      ];
      unifiedSystemDir = true;
    };

    alma10x86_64 = {
      name = "alma-10.0-x86_64";
      fullName = "AlmaLinux 10.0 (x86_64)";
      packagesLists = [
        (fetchurl {
          url = "https://vault.almalinux.org/10.0/BaseOS/x86_64/os/repodata/4d88695fa7ccb6298897fa9682ac1ded4628df342ffe08312846225e4469e3e4-primary.xml.gz";
          hash = "sha256-TYhpX6fMtimIl/qWgqwd7UYo3zQv/ggxKEYiXkRp4+Q=";
        })
        (fetchurl {
          url = "https://vault.almalinux.org/10.0/AppStream/x86_64/os/repodata/11ac32065bae6f2c2451803458690fc550e79f93a4ea9f438930f0c228964791-primary.xml.gz";
          hash = "sha256-EawyBluubywkUYA0WGkPxVDnn5Ok6p9DiTDwwiiWR5E=";
        })
      ];
      urlPrefixes = [
        "https://vault.almalinux.org/10.0/BaseOS/x86_64/os"
        "https://vault.almalinux.org/10.0/AppStream/x86_64/os"
      ];
      archs = [
        "noarch"
        "x86_64"
      ];
      packages = commonAlmaPackages ++ [
        "annobin-plugin-gcc"
      ];
      unifiedSystemDir = true;
    };

    # Oracle provides versioned URLs for baseos (e.g., OL9/7/baseos/base/) but not for appstream.
    # We can't mix versioned baseos with rolling appstream due to package version dependencies,
    # so we use rolling URLs for both. These may need hash updates when Oracle releases new versions.
    oracle9x86_64 = {
      name = "oracle-9-x86_64";
      fullName = "Oracle Linux 9 (x86_64)";
      packagesLists = [
        (fetchurl {
          url = "https://yum.oracle.com/repo/OracleLinux/OL9/baseos/latest/x86_64/repodata/bc292d67f73fc606db1872d5ba8804da06a514efe64523247035f0d3b678fb63-primary.xml.gz";
          hash = "sha256-vCktZ/c/xgbbGHLVuogE2galFO/mRSMkcDXw07Z4+2M=";
        })
        (fetchurl {
          url = "https://yum.oracle.com/repo/OracleLinux/OL9/appstream/x86_64/repodata/6fabacadf7cdf22cbb21dc296f58e6b852d5b8ec9a927e214231477ef90083f9-primary.xml.gz";
          hash = "sha256-b6usrffN8iy7Idwpb1jmuFLVuOyakn4hQjFHfvkAg/k=";
        })
      ];
      urlPrefixes = [
        "https://yum.oracle.com/repo/OracleLinux/OL9/baseos/latest/x86_64"
        "https://yum.oracle.com/repo/OracleLinux/OL9/appstream/x86_64"
      ];
      archs = [
        "noarch"
        "x86_64"
      ];
      packages = commonOraclePackages ++ [
        "annobin"
      ];
      unifiedSystemDir = true;
    };

    # Amazon Linux 2023 uses GUID-based URLs that don't allow directory listing.
    # To update: The GUID corresponds to a specific AL2023 release version. You can find the
    # current GUID by either:
    #   1. Running an AL2023 container: `docker run -it amazonlinux:2023 dnf repolist -v`
    #      and extracting the GUID from the Repo-baseurl field
    #   2. Checking https://github.com/docker-library/repo-info/blob/master/repos/amazonlinux/local/latest.md
    #      which tracks the repository URLs from the official Docker image
    # Release notes: https://docs.aws.amazon.com/linux/al2023/release-notes/relnotes.html
    amazon2023x86_64 = {
      name = "amazon-2023-x86_64";
      fullName = "Amazon Linux 2023 (x86_64)";
      packagesList = fetchurl {
        url = "https://cdn.amazonlinux.com/al2023/core/guids/6fa961924efb4835a7e8de43c89726dca28a5cf5906f891262d8f78a31ea3aaf/x86_64/repodata/primary.xml.gz";
        hash = "sha256-Ezdsc8a2aOIbyXvQ/nyanWe1fl089VgtfegaPcu2oo4=";
      };
      urlPrefix = "https://cdn.amazonlinux.com/al2023/core/guids/6fa961924efb4835a7e8de43c89726dca28a5cf5906f891262d8f78a31ea3aaf/x86_64";
      archs = [
        "noarch"
        "x86_64"
      ];
      packages = commonAmazonPackages ++ [
        "annobin-plugin-gcc"
      ];
      unifiedSystemDir = true;
    };

  };

  # The set of supported Dpkg-based distributions.

  debDistros = {
    # Ubuntu's snapshot service returns the same data for 22.04 regardless of the timestamp in the
    # URL. The hashes don't change between mirror://ubuntu and snapshot.ubuntu.com, so this is fine.
    ubuntu2204i386 = {
      name = "ubuntu-22.04-jammy-i386";
      fullName = "Ubuntu 22.04 Jammy (i386)";
      packagesLists = [
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20260101T000000Z/dists/jammy/main/binary-i386/Packages.xz";
          hash = "sha256-iZBmwT0ep4v+V3sayybbOgZBOFFZwPGpOKtmuLMMVPQ=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20260101T000000Z/dists/jammy/universe/binary-i386/Packages.xz";
          hash = "sha256-DO2LdpZ9rDDBhWj2gvDWd0TJJVZHxKsYTKTi6GXjm1E=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20260101T000000Z/dists/jammy-updates/main/binary-i386/Packages.xz";
          hash = "sha256-g95BtOoMxacZEHMBbcMes4a1P9HKf/QGOMOPr+OKayo=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20260101T000000Z/dists/jammy-updates/universe/binary-i386/Packages.xz";
          hash = "sha256-VbazaDDJKSUyQchGmw5f+FYAr4PIXWZJSBF0WVC5j+0=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20260101T000000Z/dists/jammy-security/main/binary-i386/Packages.xz";
          hash = "sha256-SkP4PqjUAbEMtktR5WQm/3jQl9O0T2VOVTP9QIYIVkQ=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20260101T000000Z/dists/jammy-security/universe/binary-i386/Packages.xz";
          hash = "sha256-citjk8LAGSRlXgOXgf3oe9vBCUC6/DJGhRJl/3ppN9c=";
        })
      ];
      urlPrefix = "https://snapshot.ubuntu.com/ubuntu/20260101T000000Z";
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
          url = "https://snapshot.ubuntu.com/ubuntu/20260101T000000Z/dists/jammy/main/binary-amd64/Packages.xz";
          hash = "sha256-N8tX8VVMv6ccWinun/7hipqMF4K7BWjgh0t/9M6PnBE=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20260101T000000Z/dists/jammy/universe/binary-amd64/Packages.xz";
          hash = "sha256-0pyyTJP+xfQyVXBrzn60bUd5lSA52MaKwbsUpvNlXOI=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20260101T000000Z/dists/jammy-updates/main/binary-amd64/Packages.xz";
          hash = "sha256-I57YuLZ458RljXfp1xFxqQLGNJh9uu8kQC0hc88XZro=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20260101T000000Z/dists/jammy-updates/universe/binary-amd64/Packages.xz";
          hash = "sha256-ZXobWMi7tkakZ89GoyKpiRhRxMRXud0DOerSfzz5CPE=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20260101T000000Z/dists/jammy-security/main/binary-amd64/Packages.xz";
          hash = "sha256-cifTPY1iyckkaLd7dp+VPRlF0viWKrWXhM8HVWaMuUw=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20260101T000000Z/dists/jammy-security/universe/binary-amd64/Packages.xz";
          hash = "sha256-LTSOGbzkv0KrF2JM6oVT1Ml2KQkySXMbKNMBb9AyfQM=";
        })
      ];
      urlPrefix = "https://snapshot.ubuntu.com/ubuntu/20260101T000000Z";
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
          url = "https://snapshot.ubuntu.com/ubuntu/20260101T000000Z/dists/noble/main/binary-amd64/Packages.xz";
          hash = "sha256-KmoZnhAxpcJ5yzRmRtWUmT81scA91KgqqgMjmA3ZJFE=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20260101T000000Z/dists/noble/universe/binary-amd64/Packages.xz";
          hash = "sha256-upBX+huRQ4zIodJoCNAMhTif4QHQwUliVN+XI2QFWZo=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20260101T000000Z/dists/noble-updates/main/binary-amd64/Packages.xz";
          hash = "sha256-leBJ29a2C2qdIPdjSSuwkHKUSq8GEC9L0DgdxHWZ55s=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20260101T000000Z/dists/noble-updates/universe/binary-amd64/Packages.xz";
          hash = "sha256-CWYA0A4ytptWdClW3ACdIH4hKscblDh5OgxExP4VdJA=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20260101T000000Z/dists/noble-security/main/binary-amd64/Packages.xz";
          hash = "sha256-TYs8ugCYqzOleH2OebdrpB8E68PfxB+7sRb+PlfANEo=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20260101T000000Z/dists/noble-security/universe/binary-amd64/Packages.xz";
          hash = "sha256-bK9R8CUjLQ1V4GP7/KqZooSnKHF5+T5SuBs0butC82M=";
        })
      ];
      urlPrefix = "https://snapshot.ubuntu.com/ubuntu/20260101T000000Z";
      packages = commonDebPackages ++ [
        "diffutils"
        "libc-bin"
      ];
    };

    debian11i386 = {
      name = "debian-11.11-bullseye-i386";
      fullName = "Debian 11.11 Bullseye (i386)";
      packagesList = fetchurl {
        url = "https://snapshot.debian.org/archive/debian/20260105T082626Z/dists/bullseye/main/binary-i386/Packages.xz";
        hash = "sha256-kUg1VBUO6co/5bKloxncta49191oCeF05Hm399+UuDA=";
      };
      urlPrefix = "https://snapshot.debian.org/archive/debian/20260105T082626Z";
      packages = commonDebianPackages;
    };

    debian11x86_64 = {
      name = "debian-11.11-bullseye-amd64";
      fullName = "Debian 11.11 Bullseye (amd64)";
      packagesList = fetchurl {
        url = "https://snapshot.debian.org/archive/debian/20260105T082626Z/dists/bullseye/main/binary-amd64/Packages.xz";
        hash = "sha256-HDQFREKX6thkcRwY5kvOSBDbY7SDQKL52BGC2fI1rXE=";
      };
      urlPrefix = "https://snapshot.debian.org/archive/debian/20260105T082626Z";
      packages = commonDebianPackages;
    };

    debian12i386 = {
      name = "debian-12.12-bookworm-i386";
      fullName = "Debian 12.12 Bookworm (i386)";
      packagesLists = [
        (fetchurl {
          url = "https://snapshot.debian.org/archive/debian/20260105T082626Z/dists/bookworm/main/binary-i386/Packages.xz";
          hash = "sha256-nIijsNoHUYkrL6eiwN4FCLHnJy/Bv/RMvnbMIHvieVI=";
        })
        (fetchurl {
          url = "https://snapshot.debian.org/archive/debian/20260105T082626Z/dists/bookworm-backports/main/binary-i386/Packages.xz";
          hash = "sha256-/ja7+DNIKc2ZUIXiocTjLbaD2EPsfeyZcd5ndEMapp4=";
        })
      ];
      urlPrefix = "https://snapshot.debian.org/archive/debian/20260105T082626Z";
      packages = commonDebianPackages;
    };

    debian12x86_64 = {
      name = "debian-12.12-bookworm-amd64";
      fullName = "Debian 12.12 Bookworm (amd64)";
      packagesLists = [
        (fetchurl {
          url = "https://snapshot.debian.org/archive/debian/20260105T082626Z/dists/bookworm/main/binary-amd64/Packages.xz";
          hash = "sha256-PfjQeu3tXmXZhH7foSD6WyFrvY4PfwSN/v5pBeShIBE=";
        })
        (fetchurl {
          url = "https://snapshot.debian.org/archive/debian/20260105T082626Z/dists/bookworm-backports/main/binary-amd64/Packages.xz";
          hash = "sha256-S3NSvw1kX2zxzMh+WYhY58VUR7iLrTEIuXwwSK6itIs=";
        })
      ];
      urlPrefix = "https://snapshot.debian.org/archive/debian/20260105T082626Z";
      packages = commonDebianPackages;
    };

    debian13i386 = {
      name = "debian-13.2-trixie-i386";
      fullName = "Debian 13.2 Trixie (i386)";
      packagesLists = [
        (fetchurl {
          url = "https://snapshot.debian.org/archive/debian/20260105T082626Z/dists/trixie/main/binary-i386/Packages.xz";
          hash = "sha256-9zozvFZoWiv3wNe9rb+kPwSOgc5G5f4zmNpdoet5A78=";
        })
        (fetchurl {
          url = "https://snapshot.debian.org/archive/debian/20260105T082626Z/dists/trixie-backports/main/binary-i386/Packages.xz";
          hash = "sha256-hEBAQ73Jnv8zp9YvNXWLEObyrSlQNBNBj/XoofJL7eI=";
        })
      ];
      urlPrefix = "https://snapshot.debian.org/archive/debian/20260105T082626Z";
      packages = commonDebianPackages;
    };

    debian13x86_64 = {
      name = "debian-13.2-trixie-amd64";
      fullName = "Debian 13.2 Trixie (amd64)";
      packagesLists = [
        (fetchurl {
          url = "https://snapshot.debian.org/archive/debian/20260105T082626Z/dists/trixie/main/binary-amd64/Packages.xz";
          hash = "sha256-g7f+tKljUXAC4gxJfzSC8+j0GbiwRZjonv25tYuvxtU=";
        })
        (fetchurl {
          url = "https://snapshot.debian.org/archive/debian/20260105T082626Z/dists/trixie-backports/main/binary-amd64/Packages.xz";
          hash = "sha256-9OoR36FsyK7MQMLHLFMRJ9O11WKq9JCfGwnprpztxNw=";
        })
      ];
      urlPrefix = "https://snapshot.debian.org/archive/debian/20260105T082626Z";
      packages = commonDebianPackages;
    };
  };

  # Base packages for all RHEL-family distros (Fedora, Rocky, Alma, etc.)
  baseRHELFamilyPackages = [
    "autoconf"
    "automake"
    "basesystem"
    "bzip2"
    "curl"
    "diffutils"
    "findutils"
    "gawk"
    "gcc-c++"
    "glibc-gconv-extra"
    "gzip"
    "make"
    "patch"
    "perl"
    "rpm"
    "rpm-build"
    "tar"
    "unzip"
  ];

  commonFedoraPackages = baseRHELFamilyPackages ++ [
    "annobin-plugin-gcc"
    "fedora-release"
    "gcc-plugin-annobin"
    "pkgconf-pkg-config"
  ];

  commonRockyPackages = baseRHELFamilyPackages ++ [
    "gcc-plugin-annobin"
    "pkgconf"
    "rocky-release"
  ];

  commonAlmaPackages = baseRHELFamilyPackages ++ [
    "almalinux-release"
    "gcc-plugin-annobin"
    "pkgconf"
  ];

  commonOraclePackages = baseRHELFamilyPackages ++ [
    "gcc-plugin-annobin"
    "oraclelinux-release"
    "pkgconf"
  ];

  commonAmazonPackages = baseRHELFamilyPackages ++ [
    "gcc-plugin-annobin"
    "pkgconf"
    "system-release"
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
in
{
  inherit
    buildRPM
    commonDebPackages
    commonDebianPackages
    commonFedoraPackages
    commonOpenSUSEPackages
    createEmptyImage
    debClosureGenerator
    debDistros
    defaultCreateRootFS
    diskImageExtraFuns
    diskImageFuns
    diskImages
    extractFs
    extractMTDfs
    fillDiskWithDebs
    fillDiskWithRPMs
    hd
    initrd
    initrdUtils
    makeImageFromDebDist
    makeImageFromRPMDist
    makeImageTestScript
    modulesClosure
    qemu
    qemuCommandLinux
    rpmClosureGenerator
    rpmDistros
    runInLinuxImage
    runInLinuxVM
    stage1Init
    stage2Init
    vmRunCommand
    ;
}
