{ pkgs
, kernel ? pkgs.linux
, img ? "bzImage"
, storeDir ? builtins.storeDir
, rootModules ?
    [ "virtio_pci" "virtio_blk" "virtio_balloon" "virtio_rng" "ext4" "unix" "9p" "9pnet_virtio" "rtc_cmos" ]
}:

with pkgs;

rec {

  qemu = pkgs.qemu_kvm;

  qemu-220 = lib.overrideDerivation pkgs.qemu_kvm (attrs: rec {
    version = "2.2.0";
    src = fetchurl {
      url = "http://wiki.qemu.org/download/qemu-${version}.tar.bz2";
      sha256 = "1703c3scl5n07gmpilg7g2xzyxnr7jczxgx6nn4m8kv9gin9p35n";
    };
    patches = [ ../../../nixos/modules/virtualisation/azure-qemu-220-no-etc-install.patch ];
  });

  qemuProg = "${qemu}/bin/qemu-kvm";


  modulesClosure = makeModulesClosure {
    inherit kernel rootModules;
  };


  hd = "vda"; # either "sda" or "vda"


  initrdUtils = runCommand "initrd-utils"
    { buildInputs = [ nukeReferences ];
      allowedReferences = [ "out" modulesClosure ]; # prevent accidents like glibc being included in the initrd
    }
    ''
      mkdir -p $out/bin
      mkdir -p $out/lib

      # Copy what we need from Glibc.
      cp -p ${pkgs.stdenv.glibc.out}/lib/ld-linux*.so.? $out/lib
      cp -p ${pkgs.stdenv.glibc.out}/lib/libc.so.* $out/lib
      cp -p ${pkgs.stdenv.glibc.out}/lib/libm.so.* $out/lib

      # Copy BusyBox.
      cp -pd ${pkgs.busybox}/bin/* $out/bin

      # Run patchelf to make the programs refer to the copied libraries.
      for i in $out/bin/* $out/lib/*; do if ! test -L $i; then nuke-refs $i; fi; done

      for i in $out/bin/*; do
          if [ -f "$i" -a ! -L "$i" ]; then
              echo "patching $i..."
              patchelf --set-interpreter $out/lib/ld-linux*.so.? --set-rpath $out/lib $i || true
          fi
      done
    ''; # */


  createDeviceNodes = dev:
    ''
      mknod -m 666 ${dev}/null    c 1 3
      mknod -m 666 ${dev}/zero    c 1 5
      mknod -m 666 ${dev}/random  c 1 8
      mknod -m 666 ${dev}/urandom c 1 9
      mknod -m 666 ${dev}/tty     c 5 0
      mknod -m 666 ${dev}/ttyS0   c 4 64
      mknod ${dev}/rtc     c 254 0
      . /sys/class/block/${hd}/uevent
      mknod ${dev}/${hd} b $MAJOR $MINOR
    '';


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
        mountDisk=1)
          mountDisk=1
          ;;
        command=*)
          set -- $(IFS==; echo $o)
          command=$2
          ;;
        out=*)
          set -- $(IFS==; echo $o)
          export out=$2
          ;;
      esac
    done

    echo "loading kernel modules..."
    for i in $(cat ${modulesClosure}/insmod-list); do
      insmod $i
    done

    mount -t tmpfs none /dev
    ${createDeviceNodes "/dev"}

    ifconfig lo up

    mkdir /fs

    if test -z "$mountDisk"; then
      mount -t tmpfs none /fs
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
    mount -t 9p store /fs${storeDir} -o trans=virtio,version=9p2000.L,cache=loose

    mkdir -p /fs/tmp /fs/run /fs/var
    mount -t tmpfs -o "mode=1777" none /fs/tmp
    mount -t tmpfs -o "mode=755" none /fs/run
    ln -sfn /run /fs/var/run

    echo "mounting host's temporary directory..."
    mkdir -p /fs/tmp/xchg
    mount -t 9p xchg /fs/tmp/xchg -o trans=virtio,version=9p2000.L,cache=loose

    mkdir -p /fs/proc
    mount -t proc none /fs/proc

    mkdir -p /fs/sys
    mount -t sysfs none /fs/sys

    mkdir -p /fs/etc
    ln -sf /proc/mounts /fs/etc/mtab
    echo "127.0.0.1 localhost" > /fs/etc/hosts

    echo "starting stage 2 ($command)"
    exec switch_root /fs $command $out
  '';


  initrd = makeInitrd {
    contents = [
      { object = stage1Init;
        symlink = "/init";
      }
    ];
  };


  stage2Init = writeScript "vm-run-stage2" ''
    #! ${bash}/bin/sh
    source /tmp/xchg/saved-env

    # Set the system time from the hardware clock.  Works around an
    # apparent KVM > 1.5.2 bug.
    ${pkgs.utillinux}/bin/hwclock -s

    export NIX_STORE=${storeDir}
    export NIX_BUILD_TOP=/tmp
    export TMPDIR=/tmp
    export PATH=/empty
    out="$1"
    cd "$NIX_BUILD_TOP"

    if ! test -e /bin/sh; then
      ${coreutils}/bin/mkdir -p /bin
      ${coreutils}/bin/ln -s ${bash}/bin/sh /bin/sh
    fi

    # Set up automatic kernel module loading.
    export MODULE_DIR=${linux}/lib/modules/
    ${coreutils}/bin/cat <<EOF > /run/modprobe
    #! /bin/sh
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
      $origBuilder $origArgs
      echo $? > /tmp/xchg/in-vm-exit

      ${busybox}/bin/mount -o remount,ro dummy /

      ${busybox}/bin/poweroff -f
    else
      export PATH=/bin:/usr/bin:${coreutils}/bin
      echo "Starting interactive shell..."
      echo "(To run the original builder: \$origBuilder \$origArgs)"
      exec ${busybox}/bin/setsid ${bashInteractive}/bin/bash < /dev/ttyS0 &> /dev/ttyS0
    fi
  '';


  qemuCommandLinux = ''
    ${qemuProg} \
      ${lib.optionalString (pkgs.stdenv.system == "x86_64-linux") "-cpu kvm64"} \
      -nographic -no-reboot \
      -device virtio-rng-pci \
      -virtfs local,path=${storeDir},security_model=none,mount_tag=store \
      -virtfs local,path=$TMPDIR/xchg,security_model=none,mount_tag=xchg \
      -drive file=$diskImage,if=virtio,cache=unsafe,werror=report \
      -kernel ${kernel}/${img} \
      -initrd ${initrd}/initrd \
      -append "console=ttyS0 panic=1 command=${stage2Init} out=$out mountDisk=$mountDisk loglevel=4" \
      $QEMU_OPTS
  '';


  vmRunCommand = qemuCommand: writeText "vm-run" ''
    export > saved-env

    PATH=${coreutils}/bin
    mkdir xchg
    mv saved-env xchg/

    diskImage=''${diskImage:-/dev/null}

    eval "$preVM"

    if [ "$enableParallelBuilding" = 1 ]; then
      if [ ''${NIX_BUILD_CORES:-0} = 0 ]; then
        QEMU_OPTS+=" -smp cpus=$(nproc)"
      else
        QEMU_OPTS+=" -smp cpus=$NIX_BUILD_CORES"
      fi
    fi

    # Write the command to start the VM to a file so that the user can
    # debug inside the VM if the build fails (when Nix is called with
    # the -K option to preserve the temporary build directory).
    cat > ./run-vm <<EOF
    #! ${bash}/bin/sh
    diskImage=$diskImage
    TMPDIR=$TMPDIR
    cd $TMPDIR
    ${qemuCommand}
    EOF

    mkdir -p -m 0700 $out

    chmod +x ./run-vm
    source ./run-vm

    if ! test -e xchg/in-vm-exit; then
      echo "Virtual machine didn't produce an exit code."
      exit 1
    fi

    exitCode="$(cat xchg/in-vm-exit)"
    if [ "$exitCode" != "0" ]; then
      exit "$exitCode"
    fi

    eval "$postVM"
  '';


  createEmptyImage = {size, fullName}: ''
    mkdir $out
    diskImage=$out/disk-image.qcow2
    ${qemu}/bin/qemu-img create -f qcow2 $diskImage "${toString size}M"

    mkdir $out/nix-support
    echo "${fullName}" > $out/nix-support/full-name
  '';


  defaultCreateRootFS = ''
    mkdir /mnt
    ${e2fsprogs}/bin/mkfs.ext4 /dev/${hd}
    ${utillinux}/bin/mount -t ext4 /dev/${hd} /mnt

    if test -e /mnt/.debug; then
      exec ${bash}/bin/sh
    fi
    touch /mnt/.debug

    mkdir /mnt/proc /mnt/dev /mnt/sys
    ${createDeviceNodes "/mnt/dev"}
  '';


  /* Run a derivation in a Linux virtual machine (using Qemu/KVM).  By
     default, there is no disk image; the root filesystem is a tmpfs,
     and the nix store is shared with the host (via the 9P protocol).
     Thus, any pure Nix derivation should run unmodified, e.g. the
     call

       runInLinuxVM patchelf

     will build the derivation `patchelf' inside a VM.  The attribute
     `preVM' can optionally contain a shell command to be evaluated
     *before* the VM is started (i.e., on the host).  The attribute
     `memSize' specifies the memory size of the VM in megabytes,
     defaulting to 512.  The attribute `diskImage' can optionally
     specify a file system image to be attached to /dev/sda.  (Note
     that currently we expect the image to contain a filesystem, not a
     full disk image with a partition table etc.)

     If the build fails and Nix is run with the `-K' option, a script
     `run-vm' will be left behind in the temporary build directory
     that allows you to boot into the VM and debug it interactively. */

  runInLinuxVM = drv: lib.overrideDerivation drv ({ memSize ? 512, QEMU_OPTS ? "", args, builder, ... }: {
    requiredSystemFeatures = [ "kvm" ];
    builder = "${bash}/bin/sh";
    args = ["-e" (vmRunCommand qemuCommandLinux)];
    origArgs = args;
    origBuilder = builder;
    QEMU_OPTS = "${QEMU_OPTS} -m ${toString memSize}";
    passAsFile = []; # HACK fix - see https://github.com/NixOS/nixpkgs/issues/16742
  });


  extractFs = {file, fs ? null} :
    with pkgs; runInLinuxVM (
    stdenv.mkDerivation {
      name = "extract-file";
      buildInputs = [ utillinux ];
      buildCommand = ''
        ln -s ${linux}/lib /lib
        ${kmod}/bin/modprobe loop
        ${kmod}/bin/modprobe ext4
        ${kmod}/bin/modprobe hfs
        ${kmod}/bin/modprobe hfsplus
        ${kmod}/bin/modprobe squashfs
        ${kmod}/bin/modprobe iso9660
        ${kmod}/bin/modprobe ufs
        ${kmod}/bin/modprobe cramfs
        mknod /dev/loop0 b 7 0

        mkdir -p $out
        mkdir -p tmp
        mount -o loop,ro,ufstype=44bsd ${lib.optionalString (fs != null) "-t ${fs} "}${file} tmp ||
          mount -o loop,ro ${lib.optionalString (fs != null) "-t ${fs} "}${file} tmp
        cp -Rv tmp/* $out/ || exit 0
      '';
    });


  extractMTDfs = {file, fs ? null} :
    with pkgs; runInLinuxVM (
    stdenv.mkDerivation {
      name = "extract-file-mtd";
      buildInputs = [ utillinux mtdutils ];
      buildCommand = ''
        ln -s ${linux}/lib /lib
        ${kmod}/bin/modprobe mtd
        ${kmod}/bin/modprobe mtdram total_size=131072
        ${kmod}/bin/modprobe mtdchar
        ${kmod}/bin/modprobe mtdblock
        ${kmod}/bin/modprobe jffs2
        ${kmod}/bin/modprobe zlib
        mknod /dev/mtd0 c 90 0
        mknod /dev/mtdblock0 b 31 0

        mkdir -p $out
        mkdir -p tmp

        dd if=${file} of=/dev/mtd0
        mount ${lib.optionalString (fs != null) "-t ${fs} "}/dev/mtdblock0 tmp

        cp -R tmp/* $out/
      '';
    });


  /* Like runInLinuxVM, but run the build not using the stdenv from
     the Nix store, but using the tools provided by /bin, /usr/bin
     etc. from the specified filesystem image, which typically is a
     filesystem containing a non-NixOS Linux distribution. */

  runInLinuxImage = drv: runInLinuxVM (lib.overrideDerivation drv (attrs: {
    mountDisk = true;

    /* Mount `image' as the root FS, but use a temporary copy-on-write
       image since we don't want to (and can't) write to `image'. */
    preVM = ''
      diskImage=$(pwd)/disk-image.qcow2
      origImage=${attrs.diskImage}
      if test -d "$origImage"; then origImage="$origImage/disk-image.qcow2"; fi
      ${qemu}/bin/qemu-img create -b "$origImage" -f qcow2 $diskImage
    '';

    /* Inside the VM, run the stdenv setup script normally, but at the
       very end set $PATH and $SHELL to the `native' paths for the
       distribution inside the VM. */
    postHook = ''
      PATH=/usr/bin:/bin:/usr/sbin:/sbin
      SHELL=/bin/sh
      eval "$origPostHook"
    '';

    origPostHook = if attrs ? postHook then attrs.postHook else "";

    /* Don't run Nix-specific build steps like patchelf. */
    fixupPhase = "true";
  }));


  /* Create a filesystem image of the specified size and fill it with
     a set of RPM packages. */

  fillDiskWithRPMs =
    { size ? 4096, rpms, name, fullName, preInstall ? "", postInstall ? ""
    , runScripts ? true, createRootFS ? defaultCreateRootFS
    , QEMU_OPTS ? "", memSize ? 512
    , unifiedSystemDir ? false
    }:

    runInLinuxVM (stdenv.mkDerivation {
      inherit name preInstall postInstall rpms QEMU_OPTS memSize;
      preVM = createEmptyImage {inherit size fullName;};

      buildCommand = ''
        ${createRootFS}

        chroot=$(type -tP chroot)

        # Make the Nix store available in /mnt, because that's where the RPMs live.
        mkdir -p /mnt${storeDir}
        ${utillinux}/bin/mount -o bind ${storeDir} /mnt${storeDir}

        # Newer distributions like Fedora 18 require /lib etc. to be
        # symlinked to /usr.
        ${lib.optionalString unifiedSystemDir ''
          mkdir -p /mnt/usr/bin /mnt/usr/sbin /mnt/usr/lib /mnt/usr/lib64
          ln -s /usr/bin /mnt/bin
          ln -s /usr/sbin /mnt/sbin
          ln -s /usr/lib /mnt/lib
          ln -s /usr/lib64 /mnt/lib64
          ${utillinux}/bin/mount -t proc none /mnt/proc
        ''}

        echo "unpacking RPMs..."
        set +o pipefail
        for i in $rpms; do
            echo "$i..."
            ${rpm}/bin/rpm2cpio "$i" | chroot /mnt ${cpio}/bin/cpio -i --make-directories --unconditional --extract-over-symlinks
        done

        eval "$preInstall"

        echo "initialising RPM DB..."
        PATH=/usr/bin:/bin:/usr/sbin:/sbin $chroot /mnt \
          ldconfig -v || true
        PATH=/usr/bin:/bin:/usr/sbin:/sbin $chroot /mnt \
          rpm --initdb

        ${utillinux}/bin/mount -o bind /tmp /mnt/tmp

        echo "installing RPMs..."
        PATH=/usr/bin:/bin:/usr/sbin:/sbin $chroot /mnt \
          rpm -iv --nosignature ${if runScripts then "" else "--noscripts"} $rpms

        echo "running post-install script..."
        eval "$postInstall"

        rm /mnt/.debug

        ${utillinux}/bin/umount /mnt${storeDir} /mnt/tmp ${lib.optionalString unifiedSystemDir "/mnt/proc"}
        ${utillinux}/bin/umount /mnt
      '';

      passthru = { inherit fullName; };
    });


  /* Generate a script that can be used to run an interactive session
     in the given image. */

  makeImageTestScript = image: writeScript "image-test" ''
    #! ${bash}/bin/sh
    if test -z "$1"; then
      echo "Syntax: $0 <copy-on-write-temp-file>"
      exit 1
    fi
    diskImage="$1"
    if ! test -e "$diskImage"; then
      ${qemu}/bin/qemu-img create -b ${image}/disk-image.qcow2 -f qcow2 "$diskImage"
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


  /* Build RPM packages from the tarball `src' in the Linux
     distribution installed in the filesystem `diskImage'.  The
     tarball must contain an RPM specfile. */

  buildRPM = attrs: runInLinuxImage (stdenv.mkDerivation ({
    phases = "prepareImagePhase sysInfoPhase buildPhase installPhase";

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
      header "installed RPM packages"
      rpm -qa --qf "%{Name}-%{Version}-%{Release} (%{Arch}; %{Distribution}; %{Vendor})\n"
      stopNest
    '';

    buildPhase = ''
      eval "$preBuild"

      # Hacky: RPM looks for <basename>.spec inside the tarball, so
      # strip off the hash.
      srcName="$(stripHash "$src")"
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
        header "Generated RPM/SRPM: $i"
        rpm -qip $i
        stopNest
      done

      eval "$postInstall"
    ''; # */
  } // attrs));


  /* Create a filesystem image of the specified size and fill it with
     a set of Debian packages.  `debs' must be a list of list of
     .deb files, namely, the Debian packages grouped together into
     strongly connected components.  See deb/deb-closure.nix. */

  fillDiskWithDebs =
    { size ? 4096, debs, name, fullName, postInstall ? null, createRootFS ? defaultCreateRootFS
    , QEMU_OPTS ? "", memSize ? 512 }:

    runInLinuxVM (stdenv.mkDerivation {
      inherit name postInstall QEMU_OPTS memSize;

      debs = (lib.intersperse "|" debs);

      preVM = createEmptyImage {inherit size fullName;};

      buildCommand = ''
        ${createRootFS}

        PATH=$PATH:${stdenv.lib.makeBinPath [ dpkg dpkg glibc lzma ]}

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
        ${utillinux}/bin/mount -o bind ${storeDir} /mnt/inst${storeDir}
        ${utillinux}/bin/mount -o bind /proc /mnt/proc
        ${utillinux}/bin/mount -o bind /dev /mnt/dev

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
        ln -sf dash /mnt/bin/sh

        rm /mnt/.debug

        ${utillinux}/bin/umount /mnt/inst${storeDir}
        ${utillinux}/bin/umount /mnt/proc
        ${utillinux}/bin/umount /mnt/dev
        ${utillinux}/bin/umount /mnt
      '';

      passthru = { inherit fullName; };
    });


  /* Generate a Nix expression containing fetchurl calls for the
     closure of a set of top-level RPM packages from the
     `primary.xml.gz' file of a Fedora or openSUSE distribution. */

  rpmClosureGenerator =
    {name, packagesLists, urlPrefixes, packages, archs ? []}:
    assert (builtins.length packagesLists) == (builtins.length urlPrefixes);
    runCommand "${name}.nix" {buildInputs = [perl perlPackages.XMLSimple]; inherit archs;} ''
      ${lib.concatImapStrings (i: pl: ''
        gunzip < ${pl} > ./packages_${toString i}.xml
      '') packagesLists}
      perl -w ${rpm/rpm-closure.pl} \
        ${lib.concatImapStrings (i: pl: "./packages_${toString i}.xml ${pl.snd} " ) (lib.zipLists packagesLists urlPrefixes)} \
        ${toString packages} > $out
    '';


  /* Helper function that combines rpmClosureGenerator and
     fillDiskWithRPMs to generate a disk image from a set of package
     names. */

  makeImageFromRPMDist =
    { name, fullName, size ? 4096
    , urlPrefix ? "", urlPrefixes ? [urlPrefix]
    , packagesList ? "", packagesLists ? [packagesList]
    , packages, extraPackages ? []
    , preInstall ? "", postInstall ? "", archs ? ["noarch" "i386"]
    , runScripts ? true, createRootFS ? defaultCreateRootFS
    , QEMU_OPTS ? "", memSize ? 512
    , unifiedSystemDir ? false }:

    fillDiskWithRPMs {
      inherit name fullName size preInstall postInstall runScripts createRootFS unifiedSystemDir QEMU_OPTS memSize;
      rpms = import (rpmClosureGenerator {
        inherit name packagesLists urlPrefixes archs;
        packages = packages ++ extraPackages;
      }) { inherit fetchurl; };
    };


  /* Like `rpmClosureGenerator', but now for Debian/Ubuntu releases
     (i.e. generate a closure from a Packages.bz2 file). */

  debClosureGenerator =
    {name, packagesLists, urlPrefix, packages}:

    runCommand "${name}.nix" { buildInputs = [ perl dpkg ]; } ''
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

      # Work around this bug: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=452279
      sed -i ./Packages -e s/x86_64-linux-gnu/x86-64-linux-gnu/g

      perl -w ${deb/deb-closure.pl} \
        ./Packages ${urlPrefix} ${toString packages} > $out
    '';


  /* Helper function that combines debClosureGenerator and
     fillDiskWithDebs to generate a disk image from a set of package
     names. */

  makeImageFromDebDist =
    { name, fullName, size ? 4096, urlPrefix
    , packagesList ? "", packagesLists ? [packagesList]
    , packages, extraPackages ? [], postInstall ? ""
    , QEMU_OPTS ? "", memSize ? 512 }:

    let
      expr = debClosureGenerator {
        inherit name packagesLists urlPrefix;
        packages = packages ++ extraPackages;
      };
    in
      (fillDiskWithDebs {
        inherit name fullName size postInstall QEMU_OPTS memSize;
        debs = import expr {inherit fetchurl;};
      }) // {inherit expr;};


  /* The set of supported RPM-based distributions. */

  rpmDistros = {

    fedora2i386 = {
      name = "fedora-core-2-i386";
      fullName = "Fedora Core 2 (i386)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/core/2/i386/os/repodata/primary.xml.gz;
        sha256 = "1nq1k2k0nzkii737cka301f0vbd2ix2wsfvi6bblpi748q6h2w4k";
      };
      urlPrefix = mirror://fedora/linux/core/2/i386/os;
      runScripts = false;
      packages = commonFedoraPackages;
    };

    fedora3i386 = {
      name = "fedora-core-3-i386";
      fullName = "Fedora Core 3 (i386)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/core/3/i386/os/repodata/primary.xml.gz;
        sha256 = "13znspn4g1bkjkk47393k9chswgzl6nx1n0q6h2wrw52c7d9nw9i";
      };
      urlPrefix = mirror://fedora/linux/core/3/i386/os;
      archs = ["noarch" "i386" "i586"];
      runScripts = false;
      packages = commonFedoraPackages;
    };

    fedora5i386 = {
      name = "fedora-core-5-i386";
      fullName = "Fedora Core 5 (i386)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/core/5/i386/os/repodata/primary.xml.gz;
        sha256 = "0lfk4mzrpiyls8h7k9ckc3vgywbmg05zsr4ag6qakgnv9gljijig";
      };
      urlPrefix = mirror://fedora/linux/core/5/i386/os;
      packages = commonFedoraPackages ++ [ "util-linux" ];
    };

    fedora7i386 = {
      name = "fedora-7-i386";
      fullName = "Fedora 7 (i386)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/7/Everything/i386/os/repodata/primary.xml.gz;
        sha256 = "0ssfa01jbwdf566rsxm443yi8f9b1drgfpv51904bark4glgvs33";
      };
      urlPrefix = mirror://fedora/linux/releases/7/Everything/i386/os;
      packages = commonFedoraPackages;
    };

    fedora8i386 = {
      name = "fedora-8-i386";
      fullName = "Fedora 8 (i386)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/8/Everything/i386/os/repodata/primary.xml.gz;
        sha256 = "0kwf0jcp63pygpvgvwl4w58pph24xbcy6db6fnq2f3ly5myhz53n";
      };
      urlPrefix = http://archives.fedoraproject.org/pub/archive/fedora/linux/releases/8/Everything/i386/os;
      packages = commonFedoraPackages;
    };

    fedora8x86_64 = {
      name = "fedora-8-x86_64";
      fullName = "Fedora 8 (x86_64)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/8/Everything/x86_64/os/repodata/primary.xml.gz;
        sha256 = "11bfmpy3nz82zzmj5lfravvzlw514v4718adi4b06ps9zv3zpy8r";
      };
      urlPrefix = http://archives.fedoraproject.org/pub/archive/fedora/linux/releases/8/Everything/x86_64/os;
      packages = commonFedoraPackages;
      archs = ["noarch" "x86_64"];
    };

    fedora9i386 = {
      name = "fedora-9-i386";
      fullName = "Fedora 9 (i386)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/9/Everything/i386/os/repodata/primary.xml.gz;
        sha256 = "1qd7wb5hfxg4mkpf4k3w49hy0qqf704dqlj3igaibyzmrn9rvk7h";
      };
      urlPrefix = mirror://fedora/linux/releases/9/Everything/i386/os;
      packages = commonFedoraPackages ++ [ "cronie" "util-linux-ng" ];
    };

    fedora9x86_64 = {
      name = "fedora-9-x86_64";
      fullName = "Fedora 9 (x86_64)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/9/Everything/x86_64/os/repodata/primary.xml.gz;
        sha256 = "1qv68i5s6gis4fbj4lxkibx8zxw5kqxapk95lvm76ml59gm7axxx";
      };
      urlPrefix = mirror://fedora/linux/releases/9/Everything/x86_64/os;
      archs = ["noarch" "x86_64"];
      packages = commonFedoraPackages ++ [ "cronie" "util-linux-ng" ];
    };

    fedora10i386 = {
      name = "fedora-10-i386";
      fullName = "Fedora 10 (i386)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/10/Everything/i386/os/repodata/beeea88d162e76993c25b9dd8139868274ee7fa1-primary.xml.gz;
        sha256 = "17lyvzqjsxw3ll7726dpg14f9jc2p3fz5cr5cwd8hp3rkm5nfclv";
      };
      urlPrefix = mirror://fedora/linux/releases/10/Everything/i386/os;
      packages = commonFedoraPackages ++ [ "cronie" "util-linux-ng" ];
    };

    fedora10x86_64 = {
      name = "fedora-10-x86_64";
      fullName = "Fedora 10 (x86_64)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/10/Everything/x86_64/os/repodata/7958210175e86b5cc843cf4bd0bc8659e445e261-primary.xml.gz;
        sha256 = "02pzqmb26zmmzdni11dip3bar4kr54ddsrq9z4vda7ldwwkqd3py";
      };
      urlPrefix = mirror://fedora/linux/releases/10/Everything/x86_64/os;
      archs = ["noarch" "x86_64"];
      packages = commonFedoraPackages ++ [ "cronie" "util-linux-ng" ];
    };

    fedora11i386 = {
      name = "fedora-11-i386";
      fullName = "Fedora 11 (i386)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/11/Everything/i386/os/repodata/4a59e5ec0a3a55979f2045c9e6824b87feb1c8c3df12d893e9ee3057ba482485-primary.xml.gz;
        sha256 = "4a59e5ec0a3a55979f2045c9e6824b87feb1c8c3df12d893e9ee3057ba482485";
      };
      urlPrefix = mirror://fedora/linux/releases/11/Everything/i386/os;
      archs = ["noarch" "i386" "i586"];
      packages = commonFedoraPackages ++ [ "cronie" "util-linux-ng" ];
    };

    fedora11x86_64 = {
      name = "fedora-11-x86_64";
      fullName = "Fedora 11 (x86_64)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/11/Everything/x86_64/os/repodata/b3e9f0d474893d14b0352deddabc7e3ee017d038614e82d7c6d7717510d6ce7e-primary.xml.gz;
        sha256 = "b3e9f0d474893d14b0352deddabc7e3ee017d038614e82d7c6d7717510d6ce7e";
      };
      urlPrefix = mirror://fedora/linux/releases/11/Everything/x86_64/os;
      archs = ["noarch" "x86_64"];
      packages = commonFedoraPackages ++ [ "cronie" "util-linux-ng" ];
    };

    fedora12i386 = {
      name = "fedora-12-i386";
      fullName = "Fedora 12 (i386)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/12/Everything/i386/os/repodata/e27694b7824ee6bbf87af629950e6953eaddf91c73e489f5de690a7ecb9d726e-primary.xml.gz;
        sha256 = "e27694b7824ee6bbf87af629950e6953eaddf91c73e489f5de690a7ecb9d726e";
      };
      urlPrefix = mirror://fedora/linux/releases/12/Everything/i386/os;
      archs = ["noarch" "i386" "i586" "i686"];
      packages = commonFedoraPackages ++ [ "cronie" "util-linux-ng" ];
    };

    fedora12x86_64 = {
      name = "fedora-12-x86_64";
      fullName = "Fedora 12 (x86_64)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/12/Everything/x86_64/os/repodata/6b142ef02acbc77f405fbfdedd82451e692a01201471665052a0e00ba8ac0959-primary.xml.gz;
        sha256 = "6b142ef02acbc77f405fbfdedd82451e692a01201471665052a0e00ba8ac0959";
      };
      urlPrefix = mirror://fedora/linux/releases/12/Everything/x86_64/os;
      archs = ["noarch" "x86_64"];
      packages = commonFedoraPackages ++ [ "cronie" "util-linux-ng" ];
    };

    fedora13i386 = {
      name = "fedora-13-i386";
      fullName = "Fedora 13 (i386)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/13/Everything/i386/os/repodata/be70ac9e1031fd34222b2ec6cc8a337bc6fabd1d06969990955c5f358d138e35-primary.xml.gz;
        sha256 = "be70ac9e1031fd34222b2ec6cc8a337bc6fabd1d06969990955c5f358d138e35";
      };
      urlPrefix = mirror://fedora/linux/releases/13/Everything/i386/os;
      archs = ["noarch" "i386" "i586" "i686"];
      packages = commonFedoraPackages ++ [ "cronie" "util-linux-ng" ];
    };

    fedora13x86_64 = {
      name = "fedora-13-x86_64";
      fullName = "Fedora 13 (x86_64)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/13/Everything/x86_64/os/repodata/01996e6d20b0a4bf3390767bd26709932e42c54422b39005ec2dd4ef2e8b0f3a-primary.xml.gz;
        sha256 = "01996e6d20b0a4bf3390767bd26709932e42c54422b39005ec2dd4ef2e8b0f3a";
      };
      urlPrefix = mirror://fedora/linux/releases/13/Everything/x86_64/os;
      archs = ["noarch" "x86_64"];
      packages = commonFedoraPackages ++ [ "cronie" "util-linux-ng" ];
    };

    fedora16i386 = {
      name = "fedora-16-i386";
      fullName = "Fedora 16 (i386)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/16/Everything/i386/os/repodata/8d5e9b291748d8254e1e66ad2d35bdb7e020d8c2c6a84f928595597b7e546118-primary.xml.gz;
        sha256 = "8d5e9b291748d8254e1e66ad2d35bdb7e020d8c2c6a84f928595597b7e546118";
      };
      urlPrefix = mirror://fedora/linux/releases/16/Everything/i386/os;
      archs = ["noarch" "i386" "i586" "i686"];
      packages = commonFedoraPackages ++ [ "cronie" "util-linux" ];
    };

    fedora16x86_64 = {
      name = "fedora-16-x86_64";
      fullName = "Fedora 16 (x86_64)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/16/Everything/x86_64/os/repodata/3fffacc6006d9b4782e57f3f11fcb44ab2a1abf6625e4afb4bf6a1e6475dd107-primary.xml.gz;
        sha256 = "3fffacc6006d9b4782e57f3f11fcb44ab2a1abf6625e4afb4bf6a1e6475dd107";
      };
      urlPrefix = mirror://fedora/linux/releases/16/Everything/x86_64/os;
      archs = ["noarch" "x86_64"];
      packages = commonFedoraPackages ++ [ "cronie" "util-linux" ];
    };

    fedora17i386 = {
      name = "fedora-17-i386";
      fullName = "Fedora 17 (i386)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/17/Everything/i386/os/repodata/82dc1ea6d26e53a367dc6e7472113c4454c9a8ac7c98d4bfb11fd0b6f311450f-primary.xml.gz;
        sha256 = "03s527rvdl0zn6zx963wmjlcjm247h8p4x3fviks6lvfsak1xp42";
      };
      urlPrefix = mirror://fedora/linux/releases/17/Everything/i386/os;
      archs = ["noarch" "i386" "i586" "i686"];
      packages = commonFedoraPackages ++ [ "cronie" "util-linux" ];
      unifiedSystemDir = true;
    };

    fedora17x86_64 = {
      name = "fedora-17-x86_64";
      fullName = "Fedora 17 (x86_64)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/17/Everything/x86_64/os/repodata/7009de56f1a1c399930fa72094a310a40d38153c96d0b5af443914d3d6a7d811-primary.xml.gz;
        sha256 = "04fqlzbd651r8jpvbl4n7hakh3d422ir88571y9rkhx1y5bdw2bh";
      };
      urlPrefix = mirror://fedora/linux/releases/17/Everything/x86_64/os;
      archs = ["noarch" "x86_64"];
      packages = commonFedoraPackages ++ [ "cronie" "util-linux" ];
      unifiedSystemDir = true;
    };

    fedora18i386 = {
      name = "fedora-18-i386";
      fullName = "Fedora 18 (i386)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/18/Everything/i386/os/repodata/935f57e61365047b6aee346792bc68bfd24de30874ce5d26bf730a992d36678d-primary.xml.gz;
        sha256 = "935f57e61365047b6aee346792bc68bfd24de30874ce5d26bf730a992d36678d";
      };
      urlPrefix = mirror://fedora/linux/releases/18/Everything/i386/os;
      archs = ["noarch" "i386" "i586" "i686"];
      packages = commonFedoraPackages ++ [ "cronie" "util-linux" ];
      unifiedSystemDir = true;
    };

    fedora18x86_64 = {
      name = "fedora-18-x86_64";
      fullName = "Fedora 18 (x86_64)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/18/Everything/x86_64/os/repodata/463ac49f2218e404607b2eeb3c04be1a648d90293f4239bbb6a63c2fed672bea-primary.xml.gz;
        sha256 = "463ac49f2218e404607b2eeb3c04be1a648d90293f4239bbb6a63c2fed672bea";
      };
      urlPrefix = mirror://fedora/linux/releases/18/Everything/x86_64/os;
      archs = ["noarch" "x86_64"];
      packages = commonFedoraPackages ++ [ "cronie" "util-linux" ];
      unifiedSystemDir = true;
    };

    fedora19i386 = {
      name = "fedora-19-i386";
      fullName = "Fedora 19 (i386)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/19/Everything/i386/os/repodata/b72220bcdefff8b38de1c9029a630db4813e073f88c4b080ca274d133e0460d1-primary.xml.gz;
        sha256 = "b72220bcdefff8b38de1c9029a630db4813e073f88c4b080ca274d133e0460d1";
      };
      urlPrefix = mirror://fedora/linux/releases/19/Everything/i386/os;
      archs = ["noarch" "i386" "i586" "i686"];
      packages = commonFedoraPackages ++ [ "cronie" "util-linux" ];
      unifiedSystemDir = true;
    };

    fedora19x86_64 = {
      name = "fedora-19-x86_64";
      fullName = "Fedora 19 (x86_64)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/19/Everything/x86_64/os/repodata/d3f67da6461748f57a06459e6877fd07858828e256f58f032704186a65430fd3-primary.xml.gz;
        sha256 = "d3f67da6461748f57a06459e6877fd07858828e256f58f032704186a65430fd3";
      };
      urlPrefix = mirror://fedora/linux/releases/19/Everything/x86_64/os;
      archs = ["noarch" "x86_64"];
      packages = commonFedoraPackages ++ [ "cronie" "util-linux" ];
      unifiedSystemDir = true;
    };

    fedora20i386 = {
      name = "fedora-20-i386";
      fullName = "Fedora 20 (i386)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/20/Everything/i386/os/repodata/ae9c6ae73a12a64227e6b8e7b2d7e1c2a9515bd9c82f2af006c838e7a445dcb9-primary.xml.gz;
        sha256 = "1ffw8njfff680vq2lby8v5dm3af2w7bv5rxqwqkl59hj7bknm75f";
      };
      urlPrefix = mirror://fedora/linux/releases/20/Everything/i386/os;
      archs = ["noarch" "i386" "i586" "i686"];
      packages = commonFedoraPackages ++ [ "cronie" "util-linux" ];
      unifiedSystemDir = true;
    };

    fedora20x86_64 = {
      name = "fedora-20-x86_64";
      fullName = "Fedora 20 (x86_64)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/20/Everything/x86_64/os/repodata/d7777ea6ec66e1c86c3fe1900adf5bf8d877fb77dd06e439bd76bbbec4e82094-primary.xml.gz;
        sha256 = "1510x32bxfvnplwy81nxfzxpgn7qbgghm4717xnciqb6xjk7wxyp";
      };
      urlPrefix = mirror://fedora/linux/releases/20/Everything/x86_64/os;
      archs = ["noarch" "x86_64"];
      packages = commonFedoraPackages ++ [ "cronie" "util-linux" ];
      unifiedSystemDir = true;
    };

    fedora21i386 = {
      name = "fedora-21-i386";
      fullName = "Fedora 21 (i386)";
      packagesList = fetchurl rec {
        url = "mirror://fedora/linux/releases/21/Everything/i386/os/repodata/${sha256}-primary.xml.gz";
        sha256 = "a6ad1140adeef65bbc1fdcc7f8f2b356f0d20c71bbe3f1625038e7f43fc44780";
      };
      urlPrefix = mirror://fedora/linux/releases/21/Everything/i386/os;
      archs = ["noarch" "i386" "i586" "i686"];
      packages = commonFedoraPackages ++ [ "cronie" "util-linux" ];
      unifiedSystemDir = true;
    };

    fedora21x86_64 = {
      name = "fedora-21-x86_64";
      fullName = "Fedora 21 (x86_64)";
      packagesList = fetchurl rec {
        url = "mirror://fedora/linux/releases/21/Everything/x86_64/os/repodata/${sha256}-primary.xml.gz";
        sha256 = "e2a28baab2ea4632fad93f9f28144cda3458190888fdf7f2acc9bc289f397e96";
      };
      urlPrefix = mirror://fedora/linux/releases/21/Everything/x86_64/os;
      archs = ["noarch" "x86_64"];
      packages = commonFedoraPackages ++ [ "cronie" "util-linux" ];
      unifiedSystemDir = true;
    };

    fedora23i386 = {
      name = "fedora-23-i386";
      fullName = "Fedora 23 (i386)";
      packagesList = fetchurl rec {
        url = "mirror://fedora/linux/releases/23/Everything/i386/os/repodata/${sha256}-primary.xml.gz";
        sha256 = "0d1012e6c1f1d694ab5354d95005791ce8de908016d07e5ed0b9dac9b9223492";
      };
      urlPrefix = mirror://fedora/linux/releases/23/Everything/i386/os;
      archs = ["noarch" "i386" "i586" "i686"];
      packages = commonFedoraPackages ++ [ "cronie" "util-linux" ];
      unifiedSystemDir = true;
    };

    fedora23x86_64 = {
      name = "fedora-23-x86_64";
      fullName = "Fedora 23 (x86_64)";
      packagesList = fetchurl rec {
        url = "mirror://fedora/linux/releases/23/Everything/x86_64/os/repodata/${sha256}-primary.xml.gz";
        sha256 = "0fa09bb5f82e4a04890b91255f4b34360e38ede964fe8328f7377e36f06bad27";
      };
      urlPrefix = mirror://fedora/linux/releases/23/Everything/x86_64/os;
      archs = ["noarch" "x86_64"];
      packages = commonFedoraPackages ++ [ "cronie" "util-linux" ];
      unifiedSystemDir = true;
    };

    fedora24i386 = {
      name = "fedora-24-i386";
      fullName = "Fedora 24 (i386)";
      packagesList = fetchurl rec {
        url = "mirror://fedora/linux/releases/24/Everything/i386/os/repodata/${sha256}-primary.xml.gz";
        sha256 = "6928e251628da7a74b79180739a43784e534eaa744ba4bcb18c847dff541f344";
      };
      urlPrefix = mirror://fedora/linux/releases/24/Everything/i386/os;
      archs = ["noarch" "i386" "i586" "i686"];
      packages = commonFedoraPackages ++ [ "cronie" "util-linux" ];
      unifiedSystemDir = true;
    };

    fedora24x86_64 = {
      name = "fedora-24-x86_64";
      fullName = "Fedora 24 (x86_64)";
      packagesList = fetchurl rec {
        url = "mirror://fedora/linux/releases/24/Everything/x86_64/os/repodata/${sha256}-primary.xml.gz";
        sha256 = "8dcc989396ed27fadd252ba9b655019934bc3d9915f186f1f2f27e71eba7b42f";
      };
      urlPrefix = mirror://fedora/linux/releases/24/Everything/x86_64/os;
      archs = ["noarch" "x86_64"];
      packages = commonFedoraPackages ++ [ "cronie" "util-linux" ];
      unifiedSystemDir = true;
    };

    fedora25i386 = {
      name = "fedora-25-i386";
      fullName = "Fedora 25 (i386)";
      packagesList = fetchurl rec {
        url = "mirror://fedora/linux/releases/25/Everything/i386/os/repodata/${sha256}-primary.xml.gz";
        sha256 = "4d399e5eebb8d543d50e2da274348280fae07a6efcc469491784582b39d73bba";
      };
      urlPrefix = mirror://fedora/linux/releases/25/Everything/i386/os;
      archs = ["noarch" "i386" "i586" "i686"];
      packages = commonFedoraPackages ++ [ "cronie" "util-linux" ];
      unifiedSystemDir = true;
    };

    fedora25x86_64 = {
      name = "fedora-25-x86_64";
      fullName = "Fedora 25 (x86_64)";
      packagesList = fetchurl rec {
        url = "mirror://fedora/linux/releases/25/Everything/x86_64/os/repodata/${sha256}-primary.xml.gz";
        sha256 = "eaea04bff7327c49d90240992dff2be6d451a1758ef83e94825f23d4ff27e868";
      };
      urlPrefix = mirror://fedora/linux/releases/25/Everything/x86_64/os;
      archs = ["noarch" "x86_64"];
      packages = commonFedoraPackages ++ [ "cronie" "util-linux" ];
      unifiedSystemDir = true;
    };

    opensuse103i386 = {
      name = "opensuse-10.3-i586";
      fullName = "openSUSE 10.3 (i586)";
      packagesList = fetchurl {
        url = mirror://opensuse/10.3/repo/oss/suse/repodata/primary.xml.gz;
        sha256 = "0zb5kxsb755nqq9i8jdclmanacyf551ncx6a011v9jqphsvyfvd7";
      };
      urlPrefix = mirror://opensuse/10.3/repo/oss/suse/;
      archs = ["noarch" "i586"];
      packages = commonOpenSUSEPackages ++ [ "devs" ];
    };

    opensuse110i386 = {
      name = "opensuse-11.0-i586";
      fullName = "openSUSE 11.0 (i586)";
      packagesList = fetchurl {
        url = mirror://opensuse/11.0/repo/oss/suse/repodata/primary.xml.gz;
        sha256 = "13rv855aj8p3h1zpsji5xa1wpkhgq94gcxzvg05l2b68b15q3mwn";
      };
      urlPrefix = mirror://opensuse/11.0/repo/oss/suse/;
      archs = ["noarch" "i586"];
      packages = commonOpenSUSEPackages;
    };

    opensuse110x86_64 = {
      name = "opensuse-11.0-x86_64";
      fullName = "openSUSE 11.0 (x86_64)";
      packagesList = fetchurl {
        url = mirror://opensuse/11.0/repo/oss/suse/repodata/primary.xml.gz;
        sha256 = "13rv855aj8p3h1zpsji5xa1wpkhgq94gcxzvg05l2b68b15q3mwn";
      };
      urlPrefix = mirror://opensuse/11.0/repo/oss/suse/;
      archs = ["noarch" "x86_64"];
      packages = commonOpenSUSEPackages;
    };

    opensuse111i386 = {
      name = "opensuse-11.1-i586";
      fullName = "openSUSE 11.1 (i586)";
      packagesList = fetchurl {
        url = mirror://opensuse/11.1/repo/oss/suse/repodata/primary.xml.gz;
        sha256 = "1mfmp9afikj0hci1s8cpwjdr0ycbpfym9gdhci590r9fa75w221j";
      };
      urlPrefix = mirror://opensuse/11.1/repo/oss/suse/;
      archs = ["noarch" "i586"];
      packages = commonOpenSUSEPackages;
    };

    opensuse111x86_64 = {
      name = "opensuse-11.1-x86_64";
      fullName = "openSUSE 11.1 (x86_64)";
      packagesList = fetchurl {
        url = mirror://opensuse/11.1/repo/oss/suse/repodata/primary.xml.gz;
        sha256 = "1mfmp9afikj0hci1s8cpwjdr0ycbpfym9gdhci590r9fa75w221j";
      };
      urlPrefix = mirror://opensuse/11.1/repo/oss/suse/;
      archs = ["noarch" "x86_64"];
      packages = commonOpenSUSEPackages;
    };

    opensuse132i386 = {
      name = "opensuse-13.2-i586";
      fullName = "openSUSE 13.2 (i586)";
      packagesList = fetchurl {
        url = mirror://opensuse/13.2/repo/oss/suse/repodata/485e4f44e3c3ef3133accb589480933c2fe48dedfc44a7e5f9d5437cd9122a99-primary.xml.gz;
        sha256 = "0klzmk680as4sb6h1wl0ynj0dds3m70qim66wwbiqlnnp6xkf83y";
      };
      urlPrefix = mirror://opensuse/13.2/repo/oss/suse/;
      archs = ["noarch" "i586"];
      packages = commonOpenSUSEPackages;
    };

    opensuse132x86_64 = {
      name = "opensuse-13.2-x86_64";
      fullName = "openSUSE 13.2 (x86_64)";
      packagesList = fetchurl {
        url = mirror://opensuse/13.2/repo/oss/suse/repodata/485e4f44e3c3ef3133accb589480933c2fe48dedfc44a7e5f9d5437cd9122a99-primary.xml.gz;
        sha256 = "0klzmk680as4sb6h1wl0ynj0dds3m70qim66wwbiqlnnp6xkf83y";
      };
      urlPrefix = mirror://opensuse/13.2/repo/oss/suse/;
      archs = ["noarch" "x86_64"];
      packages = commonOpenSUSEPackages;
    };

    centos65i386 = {
      name = "centos-6.5-i386";
      fullName = "CentOS 6.5 (i386)";
      packagesList = fetchurl {
        url = http://vault.centos.org/6.5/os/i386/repodata/a89f27cc7d3cea431f3bd605a1e9309c32d5d409abc1b51a7b5c71c05f18a0c2-primary.xml.gz;
        sha256 = "1hm031gw0wawgcdbbhdb17adaclw63ls21fn7cgl7siwgp62g7x8";
      };
      urlPrefix = http://vault.centos.org/6.5/os/i386;
      archs = ["noarch" "i386"];
      packages = commonCentOSPackages ++ [ "procps" ];
    };

    centos65x86_64 = {
      name = "centos-6.5-x86_64";
      fullName = "CentOS 6.5 (x86_64)";
      packagesList = fetchurl {
        url = http://vault.centos.org/6.5/os/x86_64/repodata/3353e378f5cb4bb6c3b3dd2ca266c6d68a1e29c36cf99f76aea3d8e158626024-primary.xml.gz;
        sha256 = "0930c9cf3n53mrv9zybcqclix2nnqrka4b6xng1vcjybymwf6lrk";
      };
      urlPrefix = http://vault.centos.org/6.5/os/x86_64/;
      archs = ["noarch" "x86_64"];
      packages = commonCentOSPackages ++ [ "procps" ];
    };

    # Note: no i386 release for 7.x
    centos71x86_64 = {
      name = "centos-7.1-x86_64";
      fullName = "CentOS 7.1 (x86_64)";
      packagesList = fetchurl {
        url = http://vault.centos.org/7.1.1503/os/x86_64/repodata/1386c5af55bda40669bb5ed91e0a22796c3ed7325367506109b09ea2657f22bd-primary.xml.gz;
        sha256 = "1g92gxjs57mh15hm0rsk6bbkwv3r4851xnaypdlhd95xanpwb1hk";
      };
      urlPrefix = http://vault.centos.org/7.1.1503/os/x86_64;
      archs = ["noarch" "x86_64"];
      packages = commonCentOSPackages ++ [ "procps-ng" ];
    };

  };


  /* The set of supported Dpkg-based distributions. */

  debDistros = rec {

    # Interestingly, the SHA-256 hashes provided by Ubuntu in
    # http://nl.archive.ubuntu.com/ubuntu/dists/{gutsy,hardy}/Release are
    # wrong, but the SHA-1 and MD5 hashes are correct.  Intrepid is fine.

    ubuntu710i386 = {
      name = "ubuntu-7.10-gutsy-i386";
      fullName = "Ubuntu 7.10 Gutsy (i386)";
      packagesList = fetchurl {
        url = mirror://ubuntu/dists/gutsy/main/binary-i386/Packages.bz2;
        sha256 = "0fmac8svxq86a4w878g6syczvy5ff4jrdc1gajd3xd8z0dypnw27";
      };
      urlPrefix = mirror://ubuntu;
      packages = commonDebianPackages;
    };

    ubuntu804i386 = {
      name = "ubuntu-8.04-hardy-i386";
      fullName = "Ubuntu 8.04 Hardy (i386)";
      packagesList = fetchurl {
        url = mirror://ubuntu/dists/hardy/main/binary-i386/Packages.bz2;
        sha256 = "19132nc9fhdfmgmvn834lk0d8c0n3jv0ndz9inyynh9k6pc8b5hd";
      };
      urlPrefix = mirror://ubuntu;
      packages = commonDebianPackages;
    };

    ubuntu804x86_64 = {
      name = "ubuntu-8.04-hardy-amd64";
      fullName = "Ubuntu 8.04 Hardy (amd64)";
      packagesList = fetchurl {
        url = mirror://ubuntu/dists/hardy/main/binary-amd64/Packages.bz2;
        sha256 = "1xjcgh0ydixmim7kgxss0mhfw0sibpgygvgsyac4bdz9m503sj3h";
      };
      urlPrefix = mirror://ubuntu;
      packages = commonDebianPackages;
    };

    ubuntu810i386 = {
      name = "ubuntu-8.10-intrepid-i386";
      fullName = "Ubuntu 8.10 Intrepid (i386)";
      packagesList = fetchurl {
        url = mirror://ubuntu/dists/intrepid/main/binary-i386/Packages.bz2;
        sha256 = "70483d40a9e9b74598f2faede7df5d5103ee60055af7374f8db5c7e6017c4cf6";
      };
      urlPrefix = mirror://ubuntu;
      packages = commonDebianPackages;
    };

    ubuntu810x86_64 = {
      name = "ubuntu-8.10-intrepid-amd64";
      fullName = "Ubuntu 8.10 Intrepid (amd64)";
      packagesList = fetchurl {
        url = mirror://ubuntu/dists/intrepid/main/binary-amd64/Packages.bz2;
        sha256 = "01b2f3842cbdd5834446ddf91691bcf60f59a726dcefa23fb5b93fdc8ea7e27f";
      };
      urlPrefix = mirror://ubuntu;
      packages = commonDebianPackages;
    };

    ubuntu904i386 = {
      name = "ubuntu-9.04-jaunty-i386";
      fullName = "Ubuntu 9.04 Jaunty (i386)";
      packagesList = fetchurl {
        url = mirror://ubuntu/dists/jaunty/main/binary-i386/Packages.bz2;
        sha256 = "72c95e4901ad56ce8791723e2ae40bce2399f306f9956cac80e964011e1948d0";
      };
      urlPrefix = mirror://ubuntu;
      packages = commonDebianPackages;
    };

    ubuntu904x86_64 = {
      name = "ubuntu-9.04-jaunty-amd64";
      fullName = "Ubuntu 9.04 Jaunty (amd64)";
      packagesList = fetchurl {
        url = mirror://ubuntu/dists/jaunty/main/binary-amd64/Packages.bz2;
        sha256 = "af760ce04e43f066b8938b1abdeff979a642f940515659ede44f7877ca358ca8";
      };
      urlPrefix = mirror://ubuntu;
      packages = commonDebianPackages;
    };

    ubuntu910i386 = {
      name = "ubuntu-9.10-karmic-i386";
      fullName = "Ubuntu 9.10 Karmic (i386)";
      packagesList = fetchurl {
        url = mirror://ubuntu/dists/karmic/main/binary-i386/Packages.bz2;
        sha256 = "6e3e813857496f2af6cd7e6ada06b3398fa067a7992c5fd7e8bd8fa92e3548b7";
      };
      urlPrefix = mirror://ubuntu;
      packages = commonDebPackages ++ [ "diff" "mktemp" ];
    };

    ubuntu910x86_64 = {
      name = "ubuntu-9.10-karmic-amd64";
      fullName = "Ubuntu 9.10 Karmic (amd64)";
      packagesList = fetchurl {
        url = mirror://ubuntu/dists/karmic/main/binary-amd64/Packages.bz2;
        sha256 = "3a604fcb0c135eeb8b95da3e90a8fd4cfeff519b858cd3c9e62ea808cb9fec40";
      };
      urlPrefix = mirror://ubuntu;
      packages = commonDebPackages ++ [ "diff" "mktemp" ];
    };

    ubuntu1004i386 = {
      name = "ubuntu-10.04-lucid-i386";
      fullName = "Ubuntu 10.04 Lucid (i386)";
      packagesList =
        [ (fetchurl {
            url = mirror://ubuntu/dists/lucid/main/binary-i386/Packages.bz2;
            sha256 = "0e46596202a68caa754dfe0883f46047525309880c492cdd5e2d0970fcf626aa";
          })
          (fetchurl {
            url = mirror://ubuntu/dists/lucid/universe/binary-i386/Packages.bz2;
            sha256 = "13nvsb7na9igps2fdbbfpq4y8ihccmcs6x35pfyfp6rkhjgpzigy";
          })
        ];
      urlPrefix = mirror://ubuntu;
      packages = commonDebPackages ++ [ "diffutils" "mktemp" ];
    };

    ubuntu1004x86_64 = {
      name = "ubuntu-10.04-lucid-amd64";
      fullName = "Ubuntu 10.04 Lucid (amd64)";
      packagesList =
        [ (fetchurl {
            url = mirror://ubuntu/dists/lucid/main/binary-amd64/Packages.bz2;
            sha256 = "74a8f3192b0eda397d65316e0fa6cd34d5358dced41639e07d9f1047971bfef0";
          })
          (fetchurl {
            url = mirror://ubuntu/dists/lucid/universe/binary-amd64/Packages.bz2;
            sha256 = "112lbnf8rcsbbh89aci4m6gwac0jy16838aij0av8n076zwkvlj9";
          })
        ];
      urlPrefix = mirror://ubuntu;
      packages = commonDebPackages ++ [ "diffutils" "mktemp" ];
    };

    ubuntu1010i386 = {
      name = "ubuntu-10.10-maverick-i386";
      fullName = "Ubuntu 10.10 Maverick (i386)";
      packagesList =
        [ (fetchurl {
            url = mirror://ubuntu/dists/maverick/main/binary-i386/Packages.bz2;
            sha256 = "1qjs4042y03bxbxwjs3pgrs99ba6vqvjaaz6zhaxxaqj1r12dwa0";
          })
          (fetchurl {
            url = mirror://ubuntu/dists/maverick/universe/binary-i386/Packages.bz2;
            sha256 = "1g5pnhx730wj32221ic8p2q6zcka23knpyg190mvq9x7kflcbfzy";
          })
        ];
      urlPrefix = mirror://ubuntu;
      packages = commonDebPackages ++ [ "diffutils" ];
    };

    ubuntu1010x86_64 = {
      name = "ubuntu-10.10-maverick-amd64";
      fullName = "Ubuntu 10.10 Maverick (amd64)";
      packagesList =
        [ (fetchurl {
            url = mirror://ubuntu/dists/maverick/main/binary-amd64/Packages.bz2;
            sha256 = "1p0i4gp1bxd3zvckgnh1hx4vfc23rfgzd19dk5rmi61lzbzzqbgc";
          })
          (fetchurl {
            url = mirror://ubuntu/dists/maverick/universe/binary-amd64/Packages.bz2;
            sha256 = "0m26viwah29gh47p8m3jpnx6l84dhpwnms29m9bvqn1vwcrgjh0s";
          })
        ];
      urlPrefix = mirror://ubuntu;
      packages = commonDebPackages ++ [ "diffutils" ];
    };

    ubuntu1110i386 = {
      name = "ubuntu-11.10-oneiric-i386";
      fullName = "Ubuntu 11.10 Oneiric (i386)";
      packagesList =
        [ (fetchurl {
            url = mirror://ubuntu/dists/oneiric/main/binary-i386/Packages.bz2;
            sha256 = "11r1s76ppi7rwz08i20d7n4ndaj9lb9wsl9k8ww4s1c6agzpwv8a";
          })
          (fetchurl {
            url = mirror://ubuntu/dists/oneiric/universe/binary-i386/Packages.bz2;
            sha256 = "1dr59j8pjdhk07fpc0x73afcd9630kkdsbabx3bj92q71104yigz";
          })
        ];
      urlPrefix = mirror://ubuntu;
      packages = commonDebPackages ++ [ "diffutils" ];
    };

    ubuntu1110x86_64 = {
      name = "ubuntu-11.10-oneiric-amd64";
      fullName = "Ubuntu 11.10 Oneiric (amd64)";
      packagesLists =
        [ (fetchurl {
            url = mirror://ubuntu/dists/oneiric/main/binary-amd64/Packages.bz2;
            sha256 = "07k784gxwaqmyggmzczy9hjkgfp6p6dcs8rhkxw5hfzn0jaf8l2s";
          })
          (fetchurl {
            url = mirror://ubuntu/dists/oneiric/universe/binary-amd64/Packages.bz2;
            sha256 = "1v3ldxn5jnnfgs863ryd6wl3fsb3glainr1ma2zn2l5vpzhpi2h1";
          })
        ];
      urlPrefix = mirror://ubuntu;
      packages = commonDebPackages ++ [ "diffutils" ];
    };

    ubuntu1204i386 = {
      name = "ubuntu-12.04-precise-i386";
      fullName = "Ubuntu 12.04 Precise (i386)";
      packagesLists =
        [ (fetchurl {
            url = mirror://ubuntu/dists/precise/main/binary-i386/Packages.bz2;
            sha256 = "18ns9h4qhvjfcip9z55grzi371racxavgqkp6b5kfkdq2wwwax2d";
          })
          (fetchurl {
            url = mirror://ubuntu/dists/precise/universe/binary-i386/Packages.bz2;
            sha256 = "085lkzbnzkc74kfdmwdc32sfqyfz8dr0rbiifk8kx9jih3xjw2jk";
          })
        ];
      urlPrefix = mirror://ubuntu;
      packages = commonDebPackages ++ [ "diffutils" ];
    };

    ubuntu1204x86_64 = {
      name = "ubuntu-12.04-precise-amd64";
      fullName = "Ubuntu 12.04 Precise (amd64)";
      packagesList =
        [ (fetchurl {
            url = mirror://ubuntu/dists/precise/main/binary-amd64/Packages.bz2;
            sha256 = "1aabpn0hdih6cbabyn87yvhccqj44q9k03mqmjsb920iqlckl3fc";
          })
          (fetchurl {
            url = mirror://ubuntu/dists/precise/universe/binary-amd64/Packages.bz2;
            sha256 = "0x4hz5aplximgb7gnpvrhkw8m7a40s80rkm5b8hil0afblwlg4vr";
          })
        ];
      urlPrefix = mirror://ubuntu;
      packages = commonDebPackages ++ [ "diffutils" ];
    };

    ubuntu1210i386 = {
      name = "ubuntu-12.10-quantal-i386";
      fullName = "Ubuntu 12.10 Quantal (i386)";
      packagesLists =
        [ (fetchurl {
            url = mirror://ubuntu/dists/quantal/main/binary-i386/Packages.bz2;
            sha256 = "bee3200ac8f037700ccd2311fb8b0de665bd02d46bdb2ae946cf50c5885001c3";
          })
          (fetchurl {
            url = mirror://ubuntu/dists/quantal/universe/binary-i386/Packages.bz2;
            sha256 = "9933ce12e7830b9c68a4aead08b86fcbb8d6ef0ea1fd133f0cf9d7126ad8c9bd";
          })
        ];
      urlPrefix = mirror://ubuntu;
      packages = commonDebPackages ++ [ "diffutils" ];
    };

    ubuntu1210x86_64 = {
      name = "ubuntu-12.10-quantal-amd64";
      fullName = "Ubuntu 12.10 Quantal (amd64)";
      packagesList =
        [ (fetchurl {
            url = mirror://ubuntu/dists/quantal/main/binary-amd64/Packages.bz2;
            sha256 = "ef14073f335ef118ebe1c7d45f5a0c17ef28f72abb57c10b9082ab5e04b5d003";
          })
          (fetchurl {
            url = mirror://ubuntu/dists/quantal/universe/binary-amd64/Packages.bz2;
            sha256 = "329a98312248c98092f8b91f232fc68fd3e6e2337ea4f348b3785465ae8dae17";
          })
        ];
      urlPrefix = mirror://ubuntu;
      packages = commonDebPackages ++ [ "diffutils" ];
    };

    ubuntu1304i386 = {
      name = "ubuntu-13.04-raring-i386";
      fullName = "Ubuntu 13.04 Raring (i386)";
      packagesLists =
        [ (fetchurl {
            url = mirror://ubuntu/dists/raring/main/binary-i386/Packages.bz2;
            sha256 = "b7da6802c5302439d9abf05ebe1ab4c3b82d7be9356f51a12c5bf4994f009181";
          })
          (fetchurl {
            url = mirror://ubuntu/dists/raring/universe/binary-i386/Packages.bz2;
            sha256 = "c1a59dd9132654194f4470932fd0f1582496465d8f96909b22accaf9f404024a";
          })
        ];
      urlPrefix = mirror://ubuntu;
      packages = commonDebPackages ++ [ "diffutils" "libc-bin" ];
    };

    ubuntu1304x86_64 = {
      name = "ubuntu-13.04-raring-amd64";
      fullName = "Ubuntu 13.04 Raring (amd64)";
      packagesList =
        [ (fetchurl {
            url = mirror://ubuntu/dists/raring/main/binary-amd64/Packages.bz2;
            sha256 = "9ee6a67bedbda80b668a868bb81b5b3f30bbabac01f69d2a08961c37c8536356";
          })
          (fetchurl {
            url = mirror://ubuntu/dists/raring/universe/binary-amd64/Packages.bz2;
            sha256 = "8aba137ae18540a12de03a564c11496431a150ab2d4d1e93e2b4b691fa2a4850";
          })
        ];
      urlPrefix = mirror://ubuntu;
      packages = commonDebPackages ++ [ "diffutils" "libc-bin" ];
    };

    ubuntu1310i386 = {
      name = "ubuntu-13.10-saucy-i386";
      fullName = "Ubuntu 13.10 Saucy (i386)";
      packagesLists =
        [ (fetchurl {
            url = mirror://ubuntu/dists/saucy/main/binary-i386/Packages.bz2;
            sha256 = "9b35d44a737e6aa7e1cb5e2b52ba0ed8717c8820b3950c2e7ade07024db9c138";
          })
          (fetchurl {
            url = mirror://ubuntu/dists/saucy/universe/binary-i386/Packages.bz2;
            sha256 = "897f64c19a742ac8524c17c1b5ec31b33ec8ab20c85463010d8bf04f5d14aa0f";
          })
        ];
      urlPrefix = mirror://ubuntu;
      packages = commonDebPackages ++ [ "diffutils" "libc-bin" ];
    };

    ubuntu1310x86_64 = {
      name = "ubuntu-13.10-saucy-amd64";
      fullName = "Ubuntu 13.10 Saucy (amd64)";
      packagesList =
        [ (fetchurl {
            url = mirror://ubuntu/dists/saucy/main/binary-amd64/Packages.bz2;
            sha256 = "d000968f9653d7c25928002b0850fe2da97607682f63a351eb2c89896a219a12";
          })
          (fetchurl {
            url = mirror://ubuntu/dists/saucy/universe/binary-amd64/Packages.bz2;
            sha256 = "a899ce5513ce8540ce9b8da4c1cd85b16b231900881b3aa559f7ac3182cdbfc8";
          })
        ];
      urlPrefix = mirror://ubuntu;
      packages = commonDebPackages ++ [ "diffutils" "libc-bin" ];
    };

    ubuntu1404i386 = {
      name = "ubuntu-14.04-trusty-i386";
      fullName = "Ubuntu 14.04 Trusty (i386)";
      packagesLists =
        [ (fetchurl {
            url = mirror://ubuntu/dists/trusty/main/binary-i386/Packages.bz2;
            sha256 = "fdfc38663915c5cef3029872deb8c3bf52b98092073058086e2f1db0c71ebeb4";
          })
          (fetchurl {
            url = mirror://ubuntu/dists/trusty/universe/binary-i386/Packages.bz2;
            sha256 = "2afcf259332d88c5e02f5446c4926edd567ef1a00ce24ca7cb400cbf44e2a90f";
          })
        ];
      urlPrefix = mirror://ubuntu;
      packages = commonDebPackages ++ [ "diffutils" "libc-bin" ];
    };

    ubuntu1404x86_64 = {
      name = "ubuntu-14.04-trusty-amd64";
      fullName = "Ubuntu 14.04 Trusty (amd64)";
      packagesList =
        [ (fetchurl {
            url = mirror://ubuntu/dists/trusty/main/binary-amd64/Packages.bz2;
            sha256 = "7095917eb8e4ac9161bc3b2ceeaf86e9265aae7b855a0e15d72096ecb05f1fc2";
          })
          (fetchurl {
            url = mirror://ubuntu/dists/trusty/universe/binary-amd64/Packages.bz2;
            sha256 = "558637eeb8e340b871653e2060effe36e064677eca4eae62d9e4138dd402a610";
          })
        ];
      urlPrefix = mirror://ubuntu;
      packages = commonDebPackages ++ [ "diffutils" "libc-bin" ];
    };

    ubuntu1410i386 = {
      name = "ubuntu-14.10-utopic-i386";
      fullName = "Ubuntu 14.10 Utopic (i386)";
      packagesLists =
        [ (fetchurl {
            url = mirror://ubuntu/dists/utopic/main/binary-i386/Packages.bz2;
            sha256 = "dc33a906ccb5625740251da759393d7daace65013d421c79fdd6c99a6490d989";
          })
          (fetchurl {
            url = mirror://ubuntu/dists/utopic/universe/binary-i386/Packages.bz2;
            sha256 = "e50553c033d9e478507405e63ce7d43c8060368ea851eca0c93b75b72fd85167";
          })
        ];
      urlPrefix = mirror://ubuntu;
      packages = commonDebPackages ++ [ "diffutils" "libc-bin" ];
    };

    ubuntu1410x86_64 = {
      name = "ubuntu-14.10-utopic-amd64";
      fullName = "Ubuntu 14.10 Utopic (amd64)";
      packagesList =
        [ (fetchurl {
            url = mirror://ubuntu/dists/utopic/main/binary-amd64/Packages.bz2;
            sha256 = "9650775abec90a24c26dbb03f91a488180309144338f64f7044f7119d60d7182";
          })
          (fetchurl {
            url = mirror://ubuntu/dists/utopic/universe/binary-amd64/Packages.bz2;
            sha256 = "2acf0e39e64b4fd6d2b68b55c598fc167d7c3cabae233fc31a1e6b69eb6ecc63";
          })
        ];
      urlPrefix = mirror://ubuntu;
      packages = commonDebPackages ++ [ "diffutils" "libc-bin" ];
    };

    ubuntu1504i386 = {
      name = "ubuntu-15.04-vivid-i386";
      fullName = "Ubuntu 15.04 Vivid (i386)";
      packagesLists =
        [ (fetchurl {
            url = mirror://ubuntu/dists/vivid/main/binary-i386/Packages.bz2;
            sha256 = "0bf587152fa3fc3524bf3a3caaf46ea43cc640a27b2b448577232f014a3ec1e4";
          })
          (fetchurl {
            url = mirror://ubuntu/dists/vivid/universe/binary-i386/Packages.bz2;
            sha256 = "3452cff96eb715ca36b73d4d0cdffbf06064cbc30b1097e334a2e493b94c7fac";
          })
        ];
      urlPrefix = mirror://ubuntu;
      packages = commonDebPackages ++ [ "diffutils" "libc-bin" ];
    };

    ubuntu1504x86_64 = {
      name = "ubuntu-15.04-vivid-amd64";
      fullName = "Ubuntu 15.04 Vivid (amd64)";
      packagesList =
        [ (fetchurl {
            url = mirror://ubuntu/dists/vivid/main/binary-amd64/Packages.bz2;
            sha256 = "8f22c9bd389822702e65713e816250aa0d5829d6b3d75fd34f068de5f93de1d9";
          })
          (fetchurl {
            url = mirror://ubuntu/dists/vivid/universe/binary-amd64/Packages.bz2;
            sha256 = "feb88768e245a63ee04b0f3bcfc8899a1f03b2f831646dc2a59e4e58884b5cb9";
          })
        ];
      urlPrefix = mirror://ubuntu;
      packages = commonDebPackages ++ [ "diffutils" "libc-bin" ];
    };

    ubuntu1510i386 = {
      name = "ubuntu-15.10-wily-i386";
      fullName = "Ubuntu 15.10 Wily (i386)";
      packagesLists =
        [ (fetchurl {
            url = mirror://ubuntu/dists/wily/main/binary-i386/Packages.bz2;
            sha256 = "ac9821095c63436fd4286539592295dd5de99bc82300f628e7a74111bb5dc370";
          })
          (fetchurl {
            url = mirror://ubuntu/dists/wily/universe/binary-i386/Packages.bz2;
            sha256 = "8951294f36c0755e945e8c37fdd046319f50553a8987ead1b68b21ffa53c5f7f";
          })
        ];
      urlPrefix = mirror://ubuntu;
      packages = commonDebPackages ++ [ "diffutils" "libc-bin" ];
    };

    ubuntu1510x86_64 = {
      name = "ubuntu-15.10-wily-amd64";
      fullName = "Ubuntu 15.10 Wily (amd64)";
      packagesList =
        [ (fetchurl {
            url = mirror://ubuntu/dists/wily/main/binary-amd64/Packages.bz2;
            sha256 = "2877de7674c8c6a410c3ac479e46fec24164a4de250f22b3ff062073e3985013";
          })
          (fetchurl {
            url = mirror://ubuntu/dists/wily/universe/binary-amd64/Packages.bz2;
            sha256 = "714be7a2fd33b8bb577901c9223039dcc12c130c9244122648ee21a625e2a66d";
          })
        ];
      urlPrefix = mirror://ubuntu;
      packages = commonDebPackages ++ [ "diffutils" "libc-bin" ];
    };

    ubuntu1604i386 = {
      name = "ubuntu-16.04-xenial-i386";
      fullName = "Ubuntu 16.04 Xenial (i386)";
      packagesLists =
        [ (fetchurl {
            url = mirror://ubuntu/dists/xenial/main/binary-i386/Packages.xz;
            sha256 = "13r75sp4slqy8w32y5dnr7pp7p3cfvavyr1g7gwnlkyrq4zx4ahy";
          })
          (fetchurl {
            url = mirror://ubuntu/dists/xenial/universe/binary-i386/Packages.xz;
            sha256 = "14fid1rqm3sc0wlygcvn0yx5aljf51c2jpd4x0zxij4019316hsh";
          })
        ];
      urlPrefix = mirror://ubuntu;
      packages = commonDebPackages ++ [ "diffutils" "libc-bin" ];
    };

    ubuntu1604x86_64 = {
      name = "ubuntu-16.04-xenial-amd64";
      fullName = "Ubuntu 16.04 Xenial (amd64)";
      packagesList =
        [ (fetchurl {
            url = mirror://ubuntu/dists/xenial/main/binary-amd64/Packages.xz;
            sha256 = "110qnkhjkkwm316fbig3aivm2595ydz6zskc4ld5cr8ngcrqm1bn";
          })
          (fetchurl {
            url = mirror://ubuntu/dists/xenial/universe/binary-amd64/Packages.xz;
            sha256 = "0mm7gj491yi6q4v0n4qkbsm94s59bvqir6fk60j73w7y4la8rg68";
          })
        ];
      urlPrefix = mirror://ubuntu;
      packages = commonDebPackages ++ [ "diffutils" "libc-bin" ];
    };

    ubuntu1610i386 = {
      name = "ubuntu-16.10-yakkety-i386";
      fullName = "Ubuntu 16.10 Yakkety (i386)";
      packagesLists =
        [ (fetchurl {
            url = mirror://ubuntu/dists/yakkety/main/binary-i386/Packages.xz;
            sha256 = "da811f582779a969f738f2366c17e075cf0da3c4f2a4ed1926093a2355fd72ba";
          })
          (fetchurl {
            url = mirror://ubuntu/dists/yakkety/universe/binary-i386/Packages.xz;
            sha256 = "5162b0a87173cd5dea7ce2273788befe36f38089d44a2379ed9dd92f76c6b2aa";
          })
        ];
      urlPrefix = mirror://ubuntu;
      packages = commonDebPackages ++ [ "diffutils" "libc-bin" ];
    };

    ubuntu1610x86_64 = {
      name = "ubuntu-16.10-yakkety-amd64";
      fullName = "Ubuntu 16.10 Yakkety (amd64)";
      packagesList =
        [ (fetchurl {
            url = mirror://ubuntu/dists/yakkety/main/binary-amd64/Packages.xz;
            sha256 = "356c4cfab0d7f77b75c473cd78b22ee7288f63b24c9739049924dc081dd2e3d1";
          })
          (fetchurl {
            url = mirror://ubuntu/dists/yakkety/universe/binary-amd64/Packages.xz;
            sha256 = "a72660f8feffd6978e3b9328c6259b5387ac0b4f33d1029e4a17091ceb5057e6";
          })
        ];
      urlPrefix = mirror://ubuntu;
      packages = commonDebPackages ++ [ "diffutils" "libc-bin" ];
    };

    debian40i386 = {
      name = "debian-4.0r9-etch-i386";
      fullName = "Debian 4.0r9 Etch (i386)";
      packagesList = fetchurl {
        url = mirror://debian/dists/etch/main/binary-i386/Packages.bz2;
        sha256 = "40eeeecc35e6895b6eb0bc601e38fe53fc985d1b1f3fea3766f34763d21f206f";
      };
      urlPrefix = mirror://debian;
      packages = commonDebianPackages;
    };

    debian40x86_64 = {
      name = "debian-4.0r9-etch-amd64";
      fullName = "Debian 4.0r9 Etch (amd64)";
      packagesList = fetchurl {
        url = mirror://debian/dists/etch/main/binary-amd64/Packages.bz2;
        sha256 = "cf1c4c7d72e0da45797b046011254d2bd83f5ecb7389c7f30d2561be3f5b2e49";
      };
      urlPrefix = mirror://debian;
      packages = commonDebianPackages;
    };

    debian50i386 = {
      name = "debian-5.0.10-lenny-i386";
      fullName = "Debian 5.0.10 Lenny (i386)";
      packagesList = fetchurl {
        url = mirror://debian/dists/lenny/main/binary-i386/Packages.bz2;
        sha256 = "fb390cf043a5b6bac50879ce1c0827882abdb560050313a6a326a03a4fc761d6";
      };
      urlPrefix = mirror://debian;
      packages = commonDebianPackages;
    };

    debian50x86_64 = {
      name = "debian-5.0.10-lenny-amd64";
      fullName = "Debian 5.0.10 Lenny (amd64)";
      packagesList = fetchurl {
        url = mirror://debian/dists/lenny/main/binary-amd64/Packages.bz2;
        sha256 = "1y4bb3n770fgwsrw8qiwsgf17k0ws2d6jmcfvqv07lj77dyj53wc";
      };
      urlPrefix = mirror://debian;
      packages = commonDebianPackages;
    };

    debian60i386 = {
      name = "debian-6.0.10-squeeze-i386";
      fullName = "Debian 6.0.10 Squeeze (i386)";
      packagesList = fetchurl {
        url = mirror://debian/dists/squeeze/main/binary-i386/Packages.bz2;
        sha256 = "c08899011a7a2b0df4da08f91eef3a80d112a247df988b1c966c9fb64c812392";
      };
      urlPrefix = mirror://debian;
      packages = commonDebianPackages;
    };

    debian60x86_64 = {
      name = "debian-6.0.10-squeeze-amd64";
      fullName = "Debian 6.0.10 Squeeze (amd64)";
      packagesList = fetchurl {
        url = mirror://debian/dists/squeeze/main/binary-amd64/Packages.bz2;
        sha256 = "3f2ebd5221b9a4bdf7224acf728a51a987c63d32df1bbc20a97f177d2f184045";
      };
      urlPrefix = mirror://debian;
      packages = commonDebianPackages;
    };

    # Backward compatibility.
    debian70i386 = debian7i386;
    debian70x86_64 = debian7x86_64;

    debian7i386 = {
      name = "debian-7.11-wheezy-i386";
      fullName = "Debian 7.11 Wheezy (i386)";
      packagesList = fetchurl {
        url = mirror://debian/dists/wheezy/main/binary-i386/Packages.bz2;
        sha256 = "57ea423dc1c0cc082cae580360f8e7192c9fd60e2ef775a4ce7f48784277462d";
      };
      urlPrefix = mirror://debian;
      packages = commonDebianPackages;
    };

    debian7x86_64 = {
      name = "debian-7.11-wheezy-amd64";
      fullName = "Debian 7.11 Wheezy (amd64)";
      packagesList = fetchurl {
        url = mirror://debian/dists/wheezy/main/binary-amd64/Packages.bz2;
        sha256 = "b400e459ce2f8af8621182c3a9ea843f0df3dc2d5662e6c6204f9406f5ff2d41";
      };
      urlPrefix = mirror://debian;
      packages = commonDebianPackages;
    };

    debian8i386 = {
      name = "debian-8.9-jessie-i386";
      fullName = "Debian 8.9 Jessie (i386)";
      packagesList = fetchurl {
        url = mirror://debian/dists/jessie/main/binary-i386/Packages.xz;
        sha256 = "3c78bdf3b693f2f37737c52d6a7718b3a545956f2a853da79f04a2d15541e811";
      };
      urlPrefix = mirror://debian;
      packages = commonDebianPackages;
    };

    debian8x86_64 = {
      name = "debian-8.9-jessie-amd64";
      fullName = "Debian 8.9 Jessie (amd64)";
      packagesList = fetchurl {
        url = mirror://debian/dists/jessie/main/binary-amd64/Packages.xz;
        sha256 = "0605589ae7a63c690f37bd2567dc12e02a2eb279d9dc200a7310072ad3593e53";
      };
      urlPrefix = mirror://debian;
      packages = commonDebianPackages;
    };
  };


  /* Common packages for Fedora images. */
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
    "pkgconfig"
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

  /* Common packages for openSUSE images. */
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


  /* Common packages for Debian/Ubuntu images. */
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
  ];

  commonDebianPackages = commonDebPackages ++ [ "sysvinit" "diff" "mktemp" ];


  /* A set of functions that build the Linux distributions specified
     in `rpmDistros' and `debDistros'.  For instance,
     `diskImageFuns.ubuntu1004x86_64 { }' builds an Ubuntu 10.04 disk
     image containing the default packages specified above.  Overrides
     of the default image parameters can be given.  In particular,
     `extraPackages' specifies the names of additional packages from
     the distribution that should be included in the image; `packages'
     allows the entire set of packages to be overriden; and `size'
     sets the size of the disk in megabytes.  E.g.,
     `diskImageFuns.ubuntu1004x86_64 { extraPackages = ["firefox"];
     size = 8192; }' builds an 8 GiB image containing Firefox in
     addition to the default packages. */
  diskImageFuns =
    (lib.mapAttrs (name: as: as2: makeImageFromRPMDist (as // as2)) rpmDistros) //
    (lib.mapAttrs (name: as: as2: makeImageFromDebDist (as // as2)) debDistros);


  /* Shorthand for `diskImageFuns.<attr> { extraPackages = ... }'. */
  diskImageExtraFuns =
    lib.mapAttrs (name: f: extraPackages: f { inherit extraPackages; }) diskImageFuns;


  /* Default disk images generated from the `rpmDistros' and
     `debDistros' sets. */
  diskImages = lib.mapAttrs (name: f: f {}) diskImageFuns;

} // import ./windows pkgs
