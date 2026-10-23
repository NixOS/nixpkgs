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
  # ----------------------------
  customQemu ? null,
  kernel ? linux,
  # Name of the kernel image file inside the `kernel` output.
  kernelImage ?
    kernel.target or (throw ''
      vmTools: the `kernel` argument (${kernel.name or "<unknown>"}) has no
      `target` attribute, so the kernel image filename cannot be determined.

      If you are passing a module tree (e.g. from `pkgs.aggregateModules`) to
      make extra modules available, pass it via `kernelModules` instead and
      keep `kernel` pointing at a real kernel derivation. Alternatively, pass
      `kernelImage` explicitly with the path of the bootable image relative
      to the `kernel` derivation output (e.g. "bzImage" or "Image").
    ''),
  # Package providing `lib/modules` for the VM initrd. Override this (e.g.
  # with `pkgs.aggregateModules [ ... ]`) to make extra kernel modules
  # available inside the VM without replacing the boot kernel.
  kernelModules ? kernel,
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
    kernel = lib.getOutput "modules" kernelModules;
    inherit rootModules;
    firmware = kernelModules;
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
    export MODULE_DIR=${lib.getOutput "modules" kernelModules}/lib/modules/
    ${coreutils}/bin/cat <<EOF > /run/modprobe
    #! ${bash}/bin/sh
    export MODULE_DIR=$MODULE_DIR
    exec ${kmod}/bin/modprobe "\$@"
    EOF
    ${coreutils}/bin/chmod 755 /run/modprobe
    echo /run/modprobe > /proc/sys/kernel/modprobe

    # For debugging: if this is the second time this image is run, or
    # `run-vm --shell` asked for it, then don't start the build again,
    # but instead drop the user into an interactive shell.
    if test -n "$origBuilder" -a ! -e /.debug -a ! -e /tmp/xchg/debug-shell; then
      exec < /dev/null
      ${coreutils}/bin/touch /.debug
      declare -a argsArray=()
      concatTo argsArray origArgs
      # Record the builder's status even when it fails: under `set -e` a
      # failing builder would otherwise end this script, and with it PID 1.
      "$origBuilder" "''${argsArray[@]}" && exitCode=0 || exitCode=$?
      echo $exitCode > /tmp/xchg/in-vm-exit

      ${busybox}/bin/mount -o remount,ro dummy /

      ${busybox}/bin/poweroff -f
    else
      export PATH=/bin:/usr/bin:${coreutils}/bin
      echo "Starting interactive shell..."
      echo "(To run the original builder: \$origBuilder \$origArgs)"
      echo "(To power off the VM: ${busybox}/bin/poweroff -f, or Ctrl-A X)"
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
      -kernel ${kernel}/${kernelImage} \
      -initrd ${initrd}/initrd \
      -append "console=${qemu-common.qemuSerialDevice} panic=1 command=${stage2Init} mountDisk=$mountDisk loglevel=4" \
      $QEMU_OPTS
  '';

  # Start the virtiofsd daemons that share the Nix store and ./xchg with the
  # VM (see qemuCommandLinux), and wait for their sockets.
  startVirtiofsd = ''
    # GitHub Actions runners seems to not allow installing seccomp filter: https://github.com/rcambrj/nix-pi-loader/issues/1#issuecomment-2605497516
    # Since we are running in a sandbox already, the difference between seccomp and none is minimal
    # File handles need CAP_DAC_READ_SEARCH, which a build never has, so do not try them; and only
    # log what might need attention, not every connect and disconnect.
    ${virtiofsd}/bin/virtiofsd --xattr --socket-path virtio-store.sock --sandbox none --seccomp none --inode-file-handles=never --log-level warn --shared-dir "${storeDir}" &
    ${virtiofsd}/bin/virtiofsd --xattr --socket-path virtio-xchg.sock --sandbox none --seccomp none --inode-file-handles=never --log-level warn --shared-dir xchg &

    # Wait until virtiofsd has created these sockets to avoid race condition.
    until [[ -e virtio-store.sock ]]; do ${coreutils}/bin/sleep 0.1; done
    until [[ -e virtio-xchg.sock ]]; do ${coreutils}/bin/sleep 0.1; done
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
      # The setup script is sourced here only so that `preVM` sees `$out` and
      # friends. `postHook` belongs to the build inside the VM, where it may
      # rely on the guest's tools (see `runInLinuxImage`), so skip it here.
      postHook=
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
      # \`./run-vm --shell\` boots into an interactive shell instead of the build.
      if [ "\''${1-}" = --shell ]; then
        ${coreutils}/bin/touch xchg/debug-shell
      else
        ${coreutils}/bin/rm -f xchg/debug-shell
      fi
      ${startVirtiofsd}

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
        env.QEMU_OPTS = "${QEMU_OPTS} -m ${toString memSize} -object memory-backend-memfd,id=mem,size=${toString memSize}M,share=on -machine memory-backend=mem";
        __structuredAttrs = true;
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
          ln -s ${kernelModules}/lib /lib
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
          cp -Rv tmp/. $out/
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
          ln -s ${kernelModules}/lib /lib
          ${kmod}/bin/modprobe mtd
          ${kmod}/bin/modprobe mtdram total_size=131072
          ${kmod}/bin/modprobe mtdblock
          ${kmod}/bin/modprobe jffs2

          mkdir -p $out
          mkdir -p tmp

          dd if=${file} of=/dev/mtd0
          mount ${lib.optionalString (fs != null) "-t ${fs} "}/dev/mtdblock0 tmp

          cp -R tmp/. $out/
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
          ${qemu}/bin/qemu-img create -F ${
            attrs.diskImageFormat or "qcow2"
          } -b "$origImage" -f qcow2 $diskImage
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
          for i in "''${rpms[@]}"; do
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
            rpm -iv --nosignature ${lib.optionalString (!runScripts) "--noscripts"} "''${rpms[@]}"

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
      diskImage=$(${coreutils}/bin/realpath "$diskImage")
      export TMPDIR=$(mktemp -d)
      cd "$TMPDIR"
      export out=/dummy
      export stdenv=${stdenv}
      export origBuilder=
      export origArgs=
      mkdir xchg
      export > xchg/saved-env
      mountDisk=1
      # virtiofs needs the guest's memory to be shared with virtiofsd.
      QEMU_OPTS="-m 1024 -object memory-backend-memfd,id=mem,size=1024M,share=on -machine memory-backend=mem ''${QEMU_OPTS:-}"
      ${startVirtiofsd}
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

          debsFlat = lib.flatten debs;
          debsGrouped = map toString debs;

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

            # Keep directory symlinks such as /bin -> usr/bin on merged-/usr
            # distributions: a package that still ships ./bin/ would otherwise
            # replace the symlink with an empty directory, taking /bin/sh with it.
            for deb in "''${debsFlat[@]}"; do
              echo "$deb..."
              dpkg-deb --fsys-tarfile "$deb" | tar -x --keep-directory-symlink -C /mnt
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

            for component in "''${debsGrouped[@]}"; do
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
        perl -w ${./rpm/rpm-closure.pl} \
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

        perl -w ${./deb/deb-closure.pl} \
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

    fedora44x86_64 = {
      name = "fedora-44-x86_64";
      fullName = "Fedora 44 (x86_64)";
      packagesList = fetchurl {
        url = "https://dl.fedoraproject.org/pub/fedora/linux/releases/44/Everything/x86_64/os/repodata/c48e47563bbf65b996c95caf4a608223f982c314cab637e6ab87dd1df67b9d26-primary.xml.zst";
        hash = "sha256-xI5HVju/ZbmWyVyvSmCCI/mCwxTKtjfmq4fdHfZ7nSY=";
      };
      urlPrefix = "https://dl.fedoraproject.org/pub/fedora/linux/releases/44/Everything/x86_64/os";
      archs = [
        "noarch"
        "x86_64"
      ];
      packages = commonFedoraPackages ++ [
        "gpgverify"
        "rpm-plugin-selinux"
      ];
      unifiedSystemDir = true;
    };

    # Rocky Linux's /pub/rocky/9/ URL is rolling and changes with each minor release. We use the
    # vault instead, which provides stable URLs for specific minor versions.
    rocky9x86_64 = {
      name = "rocky-9.7-x86_64";
      fullName = "Rocky Linux 9.7 (x86_64)";
      packagesLists = [
        (fetchurl {
          url = "https://dl.rockylinux.org/vault/rocky/9.7/BaseOS/x86_64/os/repodata/992a27c23b8d59070d247f034b8c646230cb24a07e95d7cdb189e56a56d56829-primary.xml.gz";
          hash = "sha256-mSonwjuNWQcNJH8DS4xkYjDLJKB+ldfNsYnlalbVaCk=";
        })
        (fetchurl {
          url = "https://dl.rockylinux.org/vault/rocky/9.7/AppStream/x86_64/os/repodata/dec99744f47487c005ffc02acc95b323c0152abf25c394cf8c0dc646b43ff0b6-primary.xml.gz";
          hash = "sha256-3smXRPR0h8AF/8AqzJWzI8AVKr8lw5TPjA3GRrQ/8LY=";
        })
      ];
      urlPrefixes = [
        "https://dl.rockylinux.org/vault/rocky/9.7/BaseOS/x86_64/os"
        "https://dl.rockylinux.org/vault/rocky/9.7/AppStream/x86_64/os"
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
      name = "rocky-10.1-x86_64";
      fullName = "Rocky Linux 10.1 (x86_64)";
      packagesLists = [
        (fetchurl {
          url = "https://dl.rockylinux.org/vault/rocky/10.1/BaseOS/x86_64/os/repodata/257e46ec2fe040f3beffe892e33ba8442574b3a42bfcd75328960b11949fc5fe-primary.xml.gz";
          hash = "sha256-JX5G7C/gQPO+/+iS4zuoRCV0s6Qr/NdTKJYLEZSfxf4=";
        })
        (fetchurl {
          url = "https://dl.rockylinux.org/vault/rocky/10.1/AppStream/x86_64/os/repodata/4e8267a2e7a627e7e6f658dec2d25597b80c0f6f5d17c56710b323f399a097b2-primary.xml.gz";
          hash = "sha256-ToJnouemJ+fm9ljewtJVl7gMD29dF8VnELMj85mgl7I=";
        })
      ];
      urlPrefixes = [
        "https://dl.rockylinux.org/vault/rocky/10.1/BaseOS/x86_64/os"
        "https://dl.rockylinux.org/vault/rocky/10.1/AppStream/x86_64/os"
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
    # The vault only carries x86_64 binaries for a minor release once its successor is out.
    alma9x86_64 = {
      name = "alma-9.7-x86_64";
      fullName = "AlmaLinux 9.7 (x86_64)";
      packagesLists = [
        (fetchurl {
          url = "https://vault.almalinux.org/9.7/BaseOS/x86_64/os/repodata/7bfb61c917da6fd4a47ab918c22a323c430ab063bda0c04440b243794e96d845-primary.xml.gz";
          hash = "sha256-e/thyRfab9SkerkYwioyPEMKsGO9oMBEQLJDeU6W2EU=";
        })
        (fetchurl {
          url = "https://vault.almalinux.org/9.7/AppStream/x86_64/os/repodata/e580727c3017b9301a175a0256565c26e800be0bfcdf4402f8cda5682bfa2f36-primary.xml.gz";
          hash = "sha256-5YByfDAXuTAaF1oCVlZcJugAvgv830QC+M2laCv6LzY=";
        })
      ];
      urlPrefixes = [
        "https://vault.almalinux.org/9.7/BaseOS/x86_64/os"
        "https://vault.almalinux.org/9.7/AppStream/x86_64/os"
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
      name = "alma-10.1-x86_64";
      fullName = "AlmaLinux 10.1 (x86_64)";
      packagesLists = [
        (fetchurl {
          url = "https://vault.almalinux.org/10.1/BaseOS/x86_64/os/repodata/da36967d75a7da5774fb326120e33e1d5c220e7e383f7f8708128bffc993badb-primary.xml.gz";
          hash = "sha256-2jaWfXWn2ld0+zJhIOM+HVwiDn44P3+HCBKL/8mTuts=";
        })
        (fetchurl {
          url = "https://vault.almalinux.org/10.1/AppStream/x86_64/os/repodata/70d2517557e43768313013c619c884ba2c0a6d6fcd5eb7611324117563c219dd-primary.xml.gz";
          hash = "sha256-cNJRdVfkN2gxMBPGGciEuiwKbW/NXrdhEyQRdWPCGd0=";
        })
      ];
      urlPrefixes = [
        "https://vault.almalinux.org/10.1/BaseOS/x86_64/os"
        "https://vault.almalinux.org/10.1/AppStream/x86_64/os"
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
          url = "https://yum.oracle.com/repo/OracleLinux/OL9/baseos/latest/x86_64/repodata/016acc77aebf68eeeaf54e4186163c701f4c9410374561dfed11b515000bec77-primary.xml.gz";
          hash = "sha256-AWrMd66/aO7q9U5BhhY8cB9MlBA3RWHf7RG1FQAL7Hc=";
        })
        (fetchurl {
          url = "https://yum.oracle.com/repo/OracleLinux/OL9/appstream/x86_64/repodata/f97e5ebb6bfc1fdc0d32c29e8b4b1a302f1b1d78b24d417e12970d51cf05636f-primary.xml.gz";
          hash = "sha256-+X5eu2v8H9wNMsKei0saMC8bHXiyTUF+EpcNUc8FY28=";
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

    # See the comment on oracle9x86_64 about rolling URLs.
    oracle10x86_64 = {
      name = "oracle-10-x86_64";
      fullName = "Oracle Linux 10 (x86_64)";
      packagesLists = [
        (fetchurl {
          url = "https://yum.oracle.com/repo/OracleLinux/OL10/baseos/latest/x86_64/repodata/fb0f0eab3d33d53d26d28f012b800cabbac3fdd3b2921a30504213f62ce17db9-primary.xml.gz";
          hash = "sha256-+w8Oqz0z1T0m0o8BK4AMq7rD/dOykhowUEIT9izhfbk=";
        })
        (fetchurl {
          url = "https://yum.oracle.com/repo/OracleLinux/OL10/appstream/x86_64/repodata/fe3a1915c11263cd8029cd310b0ff96d9aca7c5fb9dc9e15423f259dde2e79d4-primary.xml.gz";
          hash = "sha256-/joZFcESY82AKc0xCw/5bZrKfF+53J4VQj8lnd4uedQ=";
        })
      ];
      urlPrefixes = [
        "https://yum.oracle.com/repo/OracleLinux/OL10/baseos/latest/x86_64"
        "https://yum.oracle.com/repo/OracleLinux/OL10/appstream/x86_64"
      ];
      archs = [
        "noarch"
        "x86_64"
      ];
      packages = commonOraclePackages ++ [
        "annobin-plugin-gcc"
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
        url = "https://cdn.amazonlinux.com/al2023/core/guids/5775d799f6e8c33e94d68682d3490cae250052e8798e544edd2d76501d867228/x86_64/repodata/primary.xml.gz";
        hash = "sha256-Pzz1Gnvir1VsyLXPIBlniC8yatdm+aRqNjeP19DR8LE=";
      };
      urlPrefix = "https://cdn.amazonlinux.com/al2023/core/guids/5775d799f6e8c33e94d68682d3490cae250052e8798e544edd2d76501d867228/x86_64";
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
    # The Ubuntu images pin package lists from snapshot.ubuntu.com. A release pocket (e.g. `jammy`)
    # is frozen, so its hash stays put when the snapshot timestamp moves; the `-updates` and
    # `-security` pockets keep changing, so their hashes need refreshing along with the timestamp.
    ubuntu2204i386 = {
      name = "ubuntu-22.04-jammy-i386";
      fullName = "Ubuntu 22.04 Jammy (i386)";
      packagesLists = [
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20261006T000000Z/dists/jammy/main/binary-i386/Packages.xz";
          hash = "sha256-iZBmwT0ep4v+V3sayybbOgZBOFFZwPGpOKtmuLMMVPQ=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20261006T000000Z/dists/jammy/universe/binary-i386/Packages.xz";
          hash = "sha256-DO2LdpZ9rDDBhWj2gvDWd0TJJVZHxKsYTKTi6GXjm1E=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20261006T000000Z/dists/jammy-updates/main/binary-i386/Packages.xz";
          hash = "sha256-2Gz620zbVf8KB/K1OJloMrPAIeqjBydLnrXeb6blBnQ=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20261006T000000Z/dists/jammy-updates/universe/binary-i386/Packages.xz";
          hash = "sha256-6qLgdus0Qi8pidtNeCrKO8djvRaGfDG9TnyJK9cwVnI=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20261006T000000Z/dists/jammy-security/main/binary-i386/Packages.xz";
          hash = "sha256-DqODg/IRb4GOlO+8PlRmAK2i9s4C5QrgHqGKLChVZlw=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20261006T000000Z/dists/jammy-security/universe/binary-i386/Packages.xz";
          hash = "sha256-rpF3KZIwJ331oSyYjNzqBFy/bMZxUPHjtLg+cRRKe2g=";
        })
      ];
      urlPrefix = "https://snapshot.ubuntu.com/ubuntu/20261006T000000Z";
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
          url = "https://snapshot.ubuntu.com/ubuntu/20261006T000000Z/dists/jammy/main/binary-amd64/Packages.xz";
          hash = "sha256-N8tX8VVMv6ccWinun/7hipqMF4K7BWjgh0t/9M6PnBE=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20261006T000000Z/dists/jammy/universe/binary-amd64/Packages.xz";
          hash = "sha256-0pyyTJP+xfQyVXBrzn60bUd5lSA52MaKwbsUpvNlXOI=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20261006T000000Z/dists/jammy-updates/main/binary-amd64/Packages.xz";
          hash = "sha256-eTt/gy/NKFj9I3DKzTFNhrSIkreo02KQOkw97/Gu/Ek=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20261006T000000Z/dists/jammy-updates/universe/binary-amd64/Packages.xz";
          hash = "sha256-go794qHEmpAl2dpeFS1Todfs2Vm6wPVimTZUHviUHDo=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20261006T000000Z/dists/jammy-security/main/binary-amd64/Packages.xz";
          hash = "sha256-4YvHIw5BdVZxNWkOj7l93BM7Az5a7hXydSQ0eRD8R4k=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20261006T000000Z/dists/jammy-security/universe/binary-amd64/Packages.xz";
          hash = "sha256-Q7CEJugWyCIq4jn8FOhH76P0DZKcFS4M2WXlmxzL48g=";
        })
      ];
      urlPrefix = "https://snapshot.ubuntu.com/ubuntu/20261006T000000Z";
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
          url = "https://snapshot.ubuntu.com/ubuntu/20261006T000000Z/dists/noble/main/binary-amd64/Packages.xz";
          hash = "sha256-KmoZnhAxpcJ5yzRmRtWUmT81scA91KgqqgMjmA3ZJFE=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20261006T000000Z/dists/noble/universe/binary-amd64/Packages.xz";
          hash = "sha256-upBX+huRQ4zIodJoCNAMhTif4QHQwUliVN+XI2QFWZo=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20261006T000000Z/dists/noble-updates/main/binary-amd64/Packages.xz";
          hash = "sha256-9rl5/r5AaEtfwh1VzoJwkyLzlMpOYl/FZV+lhWlSGDM=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20261006T000000Z/dists/noble-updates/universe/binary-amd64/Packages.xz";
          hash = "sha256-MewIwk3CFVFunDimEElNBujjZLd/3krdla9AGDrxpZA=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20261006T000000Z/dists/noble-security/main/binary-amd64/Packages.xz";
          hash = "sha256-RYnobbYvZrqZloQMni+XqP7NHw2z7tf3kYYsvHtfNbI=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20261006T000000Z/dists/noble-security/universe/binary-amd64/Packages.xz";
          hash = "sha256-Mzg8qg+YJCJQ36UlqKB09T5eaoLYX7KBG+lggmaT+6I=";
        })
      ];
      urlPrefix = "https://snapshot.ubuntu.com/ubuntu/20261006T000000Z";
      packages = commonDebPackages ++ [
        "diffutils"
        "libc-bin"
      ];
    };

    ubuntu2604x86_64 = {
      name = "ubuntu-26.04-resolute-amd64";
      fullName = "Ubuntu 26.04 Resolute (amd64)";
      packagesLists = [
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20261006T000000Z/dists/resolute/main/binary-amd64/Packages.xz";
          hash = "sha256-7ZrEHLJj767MWgagdC3FZXDi+1/5TE8uSy+9zd1zzyQ=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20261006T000000Z/dists/resolute/universe/binary-amd64/Packages.xz";
          hash = "sha256-FYe+htZtOFQjJSFeDhCfdb1pXI8k15Os4nYgOKatWB4=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20261006T000000Z/dists/resolute-updates/main/binary-amd64/Packages.xz";
          hash = "sha256-VYms1Kfq0A8lxX7BpxvBdCNbI2CugAoehvbigYnD8n4=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20261006T000000Z/dists/resolute-updates/universe/binary-amd64/Packages.xz";
          hash = "sha256-bEy0vpjRcO4yD1CqHQcRpbOWRhe+LM7oqmCyIqILHyM=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20261006T000000Z/dists/resolute-security/main/binary-amd64/Packages.xz";
          hash = "sha256-VN96MEriyJQP0hS7QWYSNidc7cGH3ZI/dRLZFmdOjtg=";
        })
        (fetchurl {
          url = "https://snapshot.ubuntu.com/ubuntu/20261006T000000Z/dists/resolute-security/universe/binary-amd64/Packages.xz";
          hash = "sha256-KUd0UkdPfWKSgzZMjgR/knl2Crsb8sn+MWKQzp1ICmU=";
        })
      ];
      urlPrefix = "https://snapshot.ubuntu.com/ubuntu/20261006T000000Z";
      packages = commonDebPackages ++ [
        "diffutils"
        "libc-bin"
      ];
    };

    debian12i386 = {
      name = "debian-12.15-bookworm-i386";
      fullName = "Debian 12.15 Bookworm (i386)";
      packagesLists = [
        (fetchurl {
          url = "https://snapshot.debian.org/archive/debian/20261006T082722Z/dists/bookworm/main/binary-i386/Packages.xz";
          hash = "sha256-kAc58601tonSP0qX7i3HlDvrs3Y8fEH5oDBy1jlETk0=";
        })
        (fetchurl {
          url = "https://snapshot.debian.org/archive/debian/20261006T082722Z/dists/bookworm-backports/main/binary-i386/Packages.xz";
          hash = "sha256-mmG7BkW2ukVZ78fRKVOHMVtfMHl4scuPW8qWYSNoXyw=";
        })
      ];
      urlPrefix = "https://snapshot.debian.org/archive/debian/20261006T082722Z";
      packages = commonDebianPackages;
    };

    debian12x86_64 = {
      name = "debian-12.15-bookworm-amd64";
      fullName = "Debian 12.15 Bookworm (amd64)";
      packagesLists = [
        (fetchurl {
          url = "https://snapshot.debian.org/archive/debian/20261006T082722Z/dists/bookworm/main/binary-amd64/Packages.xz";
          hash = "sha256-ngtaq7JGWz0uen/if5kThGJ3gz96KCbndnrMz/W1iMU=";
        })
        (fetchurl {
          url = "https://snapshot.debian.org/archive/debian/20261006T082722Z/dists/bookworm-backports/main/binary-amd64/Packages.xz";
          hash = "sha256-t0tbvKb0cB32xdtUeTpoRJ+yZ6wQqTFOdhuXKsY7N2A=";
        })
      ];
      urlPrefix = "https://snapshot.debian.org/archive/debian/20261006T082722Z";
      packages = commonDebianPackages;
    };

    debian13i386 = {
      name = "debian-13.7-trixie-i386";
      fullName = "Debian 13.7 Trixie (i386)";
      packagesLists = [
        (fetchurl {
          url = "https://snapshot.debian.org/archive/debian/20261006T082722Z/dists/trixie/main/binary-i386/Packages.xz";
          hash = "sha256-HoZLBcwazJN3YN3N/Yz3JDR9cbm5np/7ykdos5JjTzQ=";
        })
        (fetchurl {
          url = "https://snapshot.debian.org/archive/debian/20261006T082722Z/dists/trixie-backports/main/binary-i386/Packages.xz";
          hash = "sha256-YDKi5w1LsFq8GpY7+z6UM5BFB0TRvPIlZTbZ5jei3DU=";
        })
      ];
      urlPrefix = "https://snapshot.debian.org/archive/debian/20261006T082722Z";
      packages = commonDebianPackages;
    };

    debian13x86_64 = {
      name = "debian-13.7-trixie-amd64";
      fullName = "Debian 13.7 Trixie (amd64)";
      packagesLists = [
        (fetchurl {
          url = "https://snapshot.debian.org/archive/debian/20261006T082722Z/dists/trixie/main/binary-amd64/Packages.xz";
          hash = "sha256-d3jT4/MDt924zg/nyNV0c6B2xr8ujyQfdUIdI5Y1JJg=";
        })
        (fetchurl {
          url = "https://snapshot.debian.org/archive/debian/20261006T082722Z/dists/trixie-backports/main/binary-amd64/Packages.xz";
          hash = "sha256-0yHZ3aB0k85hHSNQpY62XbTX9FTVGyfVUDtXO70RGao=";
        })
      ];
      urlPrefix = "https://snapshot.debian.org/archive/debian/20261006T082722Z";
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
    # Provides update-rc.d, which the installation scripts of packages
    # that ship a service call.
    "init-system-helpers"
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
