{ pkgs
, kernel ? pkgs.linux
, img ? pkgs.stdenv.platform.kernelTarget
, storeDir ? builtins.storeDir
, rootModules ?
    [ "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_balloon" "virtio_rng" "ext4" "unix" "9p" "9pnet_virtio" ]
      ++ pkgs.lib.optional (pkgs.stdenv.isi686 || pkgs.stdenv.isx86_64) "rtc_cmos"
}:

with pkgs;
with import ../../../nixos/lib/qemu-flags.nix { inherit pkgs; };

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


  modulesClosure = makeModulesClosure {
    inherit kernel rootModules;
    firmware = kernel;
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

    mount -t devtmpfs devtmpfs /dev

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
      exec ${busybox}/bin/setsid ${bashInteractive}/bin/bash < /dev/${qemuSerialDevice} &> /dev/${qemuSerialDevice}
    fi
  '';


  qemuCommandLinux = ''
    ${qemuBinary qemu} \
      -nographic -no-reboot \
      -device virtio-rng-pci \
      -virtfs local,path=${storeDir},security_model=none,mount_tag=store \
      -virtfs local,path=$TMPDIR/xchg,security_model=none,mount_tag=xchg \
      ''${diskImage:+-drive file=$diskImage,if=virtio,cache=unsafe,werror=report} \
      -kernel ${kernel}/${img} \
      -initrd ${initrd}/initrd \
      -append "console=${qemuSerialDevice} panic=1 command=${stage2Init} out=$out mountDisk=$mountDisk loglevel=4" \
      $QEMU_OPTS
  '';


  vmRunCommand = qemuCommand: writeText "vm-run" ''
    export > saved-env

    PATH=${coreutils}/bin
    mkdir xchg
    mv saved-env xchg/

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
    ''${diskImage:+diskImage=$diskImage}
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
    , extraDebs ? []
    , QEMU_OPTS ? "", memSize ? 512 }:

    let
      expr = debClosureGenerator {
        inherit name packagesLists urlPrefix;
        packages = packages ++ extraPackages;
      };
    in
      (fillDiskWithDebs {
        inherit name fullName size postInstall QEMU_OPTS memSize;
        debs = import expr {inherit fetchurl;} ++ extraDebs;
      }) // {inherit expr;};


  /* The set of supported RPM-based distributions. */

  rpmDistros = {

    # Note: no i386 release for Fedora >= 26
    fedora26x86_64 =
      let version = "26";
      in rec {
        name = "fedora-${version}-x86_64";
        fullName = "Fedora ${version} (x86_64)";
        packagesList = fetchurl rec {
          url = "mirror://fedora/linux/releases/${version}/Everything/x86_64/os/repodata/${sha256}-primary.xml.gz";
          sha256 = "880055a50c05b20641530d09b23f64501a000b2f92fe252417c530178730a95e";
        };
        urlPrefix = "mirror://fedora/linux/releases/${version}/Everything/x86_64/os";
        archs = ["noarch" "x86_64"];
        packages = commonFedoraPackages ++ [ "cronie" "util-linux" ];
        unifiedSystemDir = true;
      };

    fedora27x86_64 =
      let version = "27";
      in rec {
        name = "fedora-${version}-x86_64";
        fullName = "Fedora ${version} (x86_64)";
        packagesList = fetchurl rec {
          url = "mirror://fedora/linux/releases/${version}/Everything/x86_64/os/repodata/${sha256}-primary.xml.gz";
          sha256 = "48986ce4583cd09825c6d437150314446f0f49fa1a1bd62dcfa1085295030fe9";
        };
        urlPrefix = "mirror://fedora/linux/releases/${version}/Everything/x86_64/os";
        archs = ["noarch" "x86_64"];
        packages = commonFedoraPackages ++ [ "cronie" "util-linux" ];
        unifiedSystemDir = true;
      };

    centos6i386 =
      let version = "6.9";
      in rec {
        name = "centos-${version}-i386";
        fullName = "CentOS ${version} (i386)";
        # N.B. Switch to vault.centos.org when the next release comes out
        # urlPrefix = "http://vault.centos.org/${version}/os/i386";
        urlPrefix = "http://mirror.centos.org/centos-6/${version}/os/i386";
        packagesList = fetchurl rec {
          url = "${urlPrefix}/repodata/${sha256}-primary.xml.gz";
          sha256 = "b826a45082ef68340325c0855f3d2e5d5a4d0f77d28ba3b871791d6f14a97aeb";
        };
        archs = ["noarch" "i386"];
        packages = commonCentOSPackages ++ [ "procps" ];
      };

    centos6x86_64 =
      let version = "6.9";
      in rec {
        name = "centos-${version}-x86_64";
        fullName = "CentOS ${version} (x86_64)";
        # N.B. Switch to vault.centos.org when the next release comes out
        # urlPrefix = "http://vault.centos.org/${version}/os/x86_64";
        urlPrefix = "http://mirror.centos.org/centos-6/${version}/os/x86_64";
        packagesList = fetchurl rec {
          url = "${urlPrefix}/repodata/${sha256}-primary.xml.gz";
          sha256 = "ed2b2d4ac98d774d4cd3e91467e1532f7e8b0275cfc91a0d214b532dcaf1e979";
        };
        archs = ["noarch" "x86_64"];
        packages = commonCentOSPackages ++ [ "procps" ];
      };

    # Note: no i386 release for 7.x
    centos7x86_64 =
      let version = "7.4.1708";
      in rec {
        name = "centos-${version}-x86_64";
        fullName = "CentOS ${version} (x86_64)";
        # N.B. Switch to vault.centos.org when the next release comes out
        # urlPrefix = "http://vault.centos.org/${version}/os/x86_64";
        urlPrefix = "http://mirror.centos.org/centos-7/${version}/os/x86_64";
        packagesList = fetchurl rec {
          url = "${urlPrefix}/repodata/${sha256}-primary.xml.gz";
          sha256 = "b686d3a0f337323e656d9387b9a76ce6808b26255fc3a138b1a87d3b1cb95ed5";
        };
        archs = ["noarch" "x86_64"];
        packages = commonCentOSPackages ++ [ "procps-ng" ];
      };
  };


  /* The set of supported Dpkg-based distributions. */

  debDistros = rec {

    # Interestingly, the SHA-256 hashes provided by Ubuntu in
    # http://nl.archive.ubuntu.com/ubuntu/dists/{gutsy,hardy}/Release are
    # wrong, but the SHA-1 and MD5 hashes are correct.  Intrepid is fine.

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
      packagesLists =
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

    ubuntu1404i386 = {
      name = "ubuntu-14.04-trusty-i386";
      fullName = "Ubuntu 14.04 Trusty (i386)";
      packagesLists =
        [ (fetchurl {
            url = mirror://ubuntu/dists/trusty/main/binary-i386/Packages.bz2;
            sha256 = "1d5y3v3v079gdq45hc07ja0bjlmzqfwdwwlq0brwxi8m75k3iz7x";
          })
          (fetchurl {
            url = mirror://ubuntu/dists/trusty/universe/binary-i386/Packages.bz2;
            sha256 = "03x9w92by320rfklrqhcl3qpwmnxds9c8ijl5zhcb21d6dcz5z1a";
          })
        ];
      urlPrefix = mirror://ubuntu;
      packages = commonDebPackages ++ [ "diffutils" "libc-bin" ];
    };

    ubuntu1404x86_64 = {
      name = "ubuntu-14.04-trusty-amd64";
      fullName = "Ubuntu 14.04 Trusty (amd64)";
      packagesLists =
        [ (fetchurl {
            url = mirror://ubuntu/dists/trusty/main/binary-amd64/Packages.bz2;
            sha256 = "1hhzbyqfr5i0swahwnl5gfp5l9p9hspywb1vpihr3b74p1z935bh";
          })
          (fetchurl {
            url = mirror://ubuntu/dists/trusty/universe/binary-amd64/Packages.bz2;
            sha256 = "04560ba8s4z4v5iawknagrkn9q1nzvpn081ycmqvhh73p3p3g1jm";
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
      packagesLists =
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

    ubuntu1710i386 = {
      name = "ubuntu-17.10-artful-i386";
      fullName = "Ubuntu 17.10 Artful (i386)";
      packagesLists =
        [ (fetchurl {
            url = mirror://ubuntu/dists/artful/main/binary-i386/Packages.xz;
            sha256 = "18yrj4kqdzm39q0527m97h5ing58hkm9yq9iyj636zh2rclym3c8";
          })
          (fetchurl {
            url = mirror://ubuntu/dists/artful/universe/binary-i386/Packages.xz;
            sha256 = "1v0njw2w80xfmxi7by76cs8hyxlla5h3gqajlpdw5srjgx2qrm2g";
          })
        ];
      urlPrefix = mirror://ubuntu;
      packages = commonDebPackages ++ [ "diffutils" "libc-bin" ];
    };

    ubuntu1710x86_64 = {
      name = "ubuntu-17.10-artful-amd64";
      fullName = "Ubuntu 17.10 Artful (amd64)";
      packagesLists =
        [ (fetchurl {
            url = mirror://ubuntu/dists/artful/main/binary-amd64/Packages.xz;
            sha256 = "104g57j1l3vi8wb5f7rgjvjhf82ccs0vwhc59jfc4ynd51z7fqjk";
          })
          (fetchurl {
            url = mirror://ubuntu/dists/artful/universe/binary-amd64/Packages.xz;
            sha256 = "1qzs95wfy9inaskfx9cf1l5yd3aaqwzy72zzi9xyvkxi75k5gcn4";
          })
        ];
      urlPrefix = mirror://ubuntu;
      packages = commonDebPackages ++ [ "diffutils" "libc-bin" ];
    };

    debian8i386 = {
      name = "debian-8.10-jessie-i386";
      fullName = "Debian 8.10 Jessie (i386)";
      packagesList = fetchurl {
        url = mirror://debian/dists/jessie/main/binary-i386/Packages.xz;
        sha256 = "1w1gm195dcrndy5486kcv0h9l3br9dqnqyyhmavp4vr5w2zk7amk";
      };
      urlPrefix = mirror://debian;
      packages = commonDebianPackages;
    };

    debian8x86_64 = {
      name = "debian-8.10-jessie-amd64";
      fullName = "Debian 8.10 Jessie (amd64)";
      packagesList = fetchurl {
        url = mirror://debian/dists/jessie/main/binary-amd64/Packages.xz;
        sha256 = "045700qsrmd3lng2rw8nfs5ci7pf660lwl6alpzkyjikyp6pg7k8";
      };
      urlPrefix = mirror://debian;
      packages = commonDebianPackages;
    };

    debian9i386 = {
      name = "debian-9.3-stretch-i386";
      fullName = "Debian 9.3 Stretch (i386)";
      packagesList = fetchurl {
        url = mirror://debian/dists/stretch/main/binary-i386/Packages.xz;
        sha256 = "1rpv0r92pkr9dmjvpffvgmq3an1s83npfmq870h67jqag3qpwj9l";
      };
      urlPrefix = mirror://debian;
      packages = commonDebianPackages;
    };

    debian9x86_64 = {
      name = "debian-9.3-stretch-amd64";
      fullName = "Debian 9.3 Stretch (amd64)";
      packagesList = fetchurl {
        url = mirror://debian/dists/stretch/main/binary-amd64/Packages.xz;
        sha256 = "1gnkvh7wc5yp0rw8kq8p8rlskvl0lc4cv3gdylw8qpqzy75xqlig";
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
    "passwd"
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
