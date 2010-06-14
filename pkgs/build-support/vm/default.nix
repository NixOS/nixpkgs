{ pkgs }:

with pkgs;

rec {


  inherit (linuxPackages_2_6_32) kernel;

  kvm = pkgs.qemu_kvm;


  modulesClosure = makeModulesClosure {
    inherit kernel;
    rootModules = [ "cifs" "virtio_net" "virtio_pci" "virtio_blk" "virtio_balloon" "nls_utf8" "ext2" "ext3" "unix" "sd_mod" "ata_piix" ];
  };


  hd = "vda"; # either "sda" or "vda"


  initrdUtils = runCommand "initrd-utils"
    { buildInputs = [ nukeReferences ];
      allowedReferences = [ "out" modulesClosure ]; # prevent accidents like glibc being included in the initrd
    }
    ''
      ensureDir $out/bin
      ensureDir $out/lib
      
      # Copy what we need from Glibc.
      cp -p ${glibc}/lib/ld-linux*.so.? $out/lib
      cp -p ${glibc}/lib/libc.so.* $out/lib
      cp -p ${glibc}/lib/librt.so.* $out/lib
      cp -p ${glibc}/lib/libdl.so.* $out/lib

      # Copy some utillinux stuff.
      cp ${utillinux}/bin/mount ${utillinux}/bin/umount $out/bin
      cp -pd ${utillinux}/lib/libblkid*.so.* $out/lib
      cp -pd ${utillinux}/lib/libuuid*.so.* $out/lib

      # Copy some coreutils.
      cp ${coreutils}/bin/basename $out/bin
      cp ${coreutils}/bin/mkdir $out/bin
      cp ${coreutils}/bin/mknod $out/bin
      cp ${coreutils}/bin/cat $out/bin
      cp ${coreutils}/bin/chroot $out/bin
      cp ${coreutils}/bin/sleep $out/bin
      cp ${coreutils}/bin/ln $out/bin

      # Copy some other tools.
      cp ${bash}/bin/bash $out/bin
      cp ${module_init_tools}/sbin/insmod $out/bin/insmod
      cp ${nettools}/sbin/ifconfig $out/bin
      cp ${sysvinit}/sbin/halt $out/bin
            
      # Run patchelf to make the programs refer to the copied libraries.
      for i in $out/bin/* $out/lib/*; do if ! test -L $i; then nuke-refs $i; fi; done

      for i in $out/bin/*; do
          echo "patching $i..."
          patchelf --set-interpreter $out/lib/ld-linux*.so.? --set-rpath $out/lib $i || true
      done
    ''; # */

    
  createDeviceNodes = dev:
    ''
      mknod ${dev}/null c 1 3
      mknod ${dev}/zero c 1 5
      mknod ${dev}/tty  c 5 0
      . /sys/class/block/${hd}/uevent
      mknod ${dev}/${hd} b $MAJOR $MINOR
    '';

  
  stage1Init = writeScript "vm-run-stage1" ''
    #! ${initrdUtils}/bin/bash -e
    echo START

    export PATH=${initrdUtils}/bin

    mkdir /etc
    echo -n > /etc/fstab

    mount -t proc none /proc
    mount -t sysfs none /sys

    for o in $(cat /proc/cmdline); do
      case $o in
        mountDisk=1)
          mountDisk=1
          ;;
        command=*)
          set -- $(IFS==; echo $o)
          command=$2
          ;;
        tmpDir=*)
          set -- $(IFS==; echo $o)
          export tmpDir=$2
          ;;
        out=*)
          set -- $(IFS==; echo $o)
          export out=$2
          ;;
      esac
    done

    for i in $(cat ${modulesClosure}/insmod-list); do
      args=
      case $i in
        */cifs.ko)
          args="CIFSMaxBufSize=4194304"
          ;;
      esac
      echo "loading module $(basename $i .ko)"
      insmod $i $args
    done

    mount -t tmpfs none /dev
    ${createDeviceNodes "/dev"}
    
    ifconfig eth0 up 10.0.2.15

    mkdir /fs

    if test -z "$mountDisk"; then
      mount -t tmpfs none /fs
    else
      mount -t ext2 /dev/${hd} /fs
    fi

    mkdir -p /fs/hostfs
    
    mkdir -p /fs/dev
    mount -o bind /dev /fs/dev

    for ((n = 0; n < 10; n++)); do
      echo "mounting host filesystem, attempt $n..."
      mount -t cifs //10.0.2.4/qemu /fs/hostfs -o guest,username=nobody && break
    done

    mkdir -p /fs/nix/store
    mount -o bind /fs/hostfs/nix/store /fs/nix/store
    
    mkdir -p /fs/tmp
    mount -t tmpfs -o "mode=755" none /fs/tmp

    mkdir -p /fs/proc
    mount -t proc none /fs/proc

    mkdir -p /fs/sys
    mount -t sysfs none /fs/sys

    mkdir -p /fs/etc
    ln -sf /proc/mounts /fs/etc/mtab
    
    echo "Now running: $command"
    test -n "$command"

    set +e
    chroot /fs $command /tmp $out /hostfs/$tmpDir
    echo $? > /fs/hostfs/$tmpDir/in-vm-exit

    mount -o remount,ro dummy /fs

    echo DONE
    halt -d -p -f
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
    source $3/saved-env
    
    export NIX_STORE=/nix/store
    export NIX_BUILD_TOP="$1"
    export TMPDIR="$1"
    export PATH=/empty
    out="$2"
    export ORIG_TMPDIR="$3"
    cd "$NIX_BUILD_TOP"

    if ! test -e /bin/sh; then
      ${coreutils}/bin/mkdir -p /bin
      ${coreutils}/bin/ln -s ${bash}/bin/sh /bin/sh
    fi

    # For debugging: if this is the second time this image is run,
    # then don't start the build again, but instead drop the user into
    # an interactive shell.
    if test -n "$origBuilder" -a ! -e /.debug; then
      ${coreutils}/bin/touch /.debug
      exec $origBuilder $origArgs
    else
      export PATH=/bin:/usr/bin:${coreutils}/bin
      echo "Starting interactive shell..."
      echo "(To run the original builder: \$origBuilder \$origArgs)"
      exec ${bash}/bin/sh
    fi
  '';


  qemuCommandLinux = ''
    qemu-system-x86_64 \
      -nographic -no-reboot \
      -net nic,model=virtio -chardev socket,id=samba,path=./samba -net user,guestfwd=tcp:10.0.2.4:139-chardev:samba \
      -drive file=$diskImage,if=virtio,boot=on,cache=writeback,werror=report \
      -kernel ${kernel}/bzImage \
      -initrd ${initrd}/initrd \
      -append "console=ttyS0 panic=1 command=${stage2Init} tmpDir=$TMPDIR out=$out mountDisk=$mountDisk" \
      $QEMU_OPTS
  '';


  vmRunCommand = qemuCommand: writeText "vm-run" ''
    export > saved-env

    PATH=${coreutils}/bin:${kvm}/bin

    diskImage=''${diskImage:-/dev/null}

    eval "$preVM"

    cat > smb.conf <<EOF
      [global]
        private dir=$TMPDIR
        smb ports=0
        socket address=127.0.0.1
        pid directory=$TMPDIR
        lock directory=$TMPDIR
        log file=$TMPDIR/log.smbd
        smb passwd file=$TMPDIR/smbpasswd
        security = share
      [qemu]
        path=/
        read only=no
        guest ok=yes
    EOF

    # Write the command to start the VM to a file so that the user can
    # debug inside the VM if the build fails (when Nix is called with
    # the -K option to preserve the temporary build directory).
    cat > ./run-vm <<EOF
    #! ${bash}/bin/sh
    diskImage=$diskImage
    TMPDIR=$TMPDIR
    cd $TMPDIR
    ${socat}/bin/socat unix-listen:./samba system:'while true; do ${samba}/sbin/smbd -s $TMPDIR/smb.conf; done' > /dev/null 2>&1 &
    while [ ! -e ./samba ]; do sleep 0.1; done # ugly
    ${qemuCommand}
    EOF

    chmod +x ./run-vm
    source ./run-vm
    
    if ! test -e in-vm-exit; then
      echo "Virtual machine didn't produce an exit code."
      exit 1
    fi
    
    eval "$postVM"

    exit $(cat in-vm-exit)
  '';


  createEmptyImage = {size, fullName}: ''
    mkdir $out
    diskImage=$out/disk-image.qcow2
    qemu-img create -f qcow2 $diskImage "${toString size}M"

    mkdir $out/nix-support
    echo "${fullName}" > $out/nix-support/full-name
  '';


  createRootFS = ''
    mkdir /mnt
    ${e2fsprogs}/sbin/mke2fs -F /dev/${hd}
    ${utillinux}/bin/mount -t ext2 /dev/${hd} /mnt

    if test -e /mnt/.debug; then
      exec ${bash}/bin/sh
    fi
    touch /mnt/.debug

    mkdir /mnt/proc /mnt/dev /mnt/sys /mnt/bin
    ${createDeviceNodes "/mnt/dev"}
  '';


  /* Run a derivation in a Linux virtual machine (using Qemu/KVM).  By
     default, there is no disk image; the root filesystem is a tmpfs,
     and /nix/store is shared with the host (via the CIFS protocol to
     a Samba instance automatically started by Qemu).  Thus, any pure
     Nix derivation should run unmodified, e.g. the call

       runInLinuxVM patchelf

     will build the derivation `patchelf' inside a VM.  The attribute
     `preVM' can optionally contain a shell command to be evaluated
     *before* the VM is started (i.e., on the host).  The attribute
     `memSize' specifies the memory size of the VM in megabytes,
     defaulting to 256.  The attribute `diskImage' can optionally
     specify a file system image to be attached to /dev/sda.  (Note
     that currently we expect the image to contain a filesystem, not a
     full disk image with a partition table etc.)

     If the build fails and Nix is run with the `-K' option, a script
     `run-vm' will be left behind in the temporary build directory
     that allows you to boot into the VM and debug it interactively. */
     
  runInLinuxVM = drv: lib.overrideDerivation drv (attrs: {
    builder = "${bash}/bin/sh";
    args = ["-e" (vmRunCommand qemuCommandLinux)];
    origArgs = attrs.args;
    origBuilder = attrs.builder;
    QEMU_OPTS = "-m ${toString (if attrs ? memSize then attrs.memSize else 256)}";
  });


  qemuCommandGeneric = ''
    qemu-system-x86_64 \
      -nographic -no-reboot \
      -smb $(pwd) -hda $diskImage \
      $QEMU_OPTS
  '';

  
  /* Run a command in a x86 virtual machine image containing an
     arbitrary OS.  The VM should be configured to do the following:

     - Write log output to the serial port.

     - Mount //10.0.2.4/qemu via SMB.

     - Execute the command "cmd" on the SMB share.  It can access the
       original derivation attributes in "saved-env" on the share.

     - Produce output under "out" on the SMB share.

     - Write an exit code to "in-vm-exit" on the SMB share ("0"
       meaning success).

     - Reboot to shutdown the machine (because Qemu doesn't seem
       capable of a APM/ACPI VM shutdown).
  */
  runInGenericVM = drv: lib.overrideDerivation drv (attrs: {
    system = "i686-linux";
    builder = "${bash}/bin/sh";
    args = ["-e" (vmRunCommand qemuCommandGeneric)];
    QEMU_OPTS = "-m ${toString (if attrs ? memSize then attrs.memSize else 256)}";

    preVM = ''
      diskImage=$(pwd)/disk-image.qcow2
      origImage=${attrs.diskImage}
      if test -d "$origImage"; then origImage="$origImage/disk-image.qcow2"; fi
      qemu-img create -b "$origImage" -f qcow2 $diskImage

      echo "$buildCommand" > cmd

      eval "$postPreVM"
    '';

    postVM = ''
      cp -prvd out $out
    '';
  });


  /* Like runInLinuxVM, but run the build not using the stdenv from
     the Nix store, but using the tools provided by /bin, /usr/bin
     etc. from the specified filesystem image, which typically is a
     filesystem containing a non-NixOS Linux distribution. */
     
  runInLinuxImage = attrs: runInLinuxVM (attrs // {
    mountDisk = true;

    /* Mount `image' as the root FS, but use a temporary copy-on-write
       image since we don't want to (and can't) write to `image'. */
    preVM = ''
      diskImage=$(pwd)/disk-image.qcow2
      origImage=${attrs.diskImage}
      if test -d "$origImage"; then origImage="$origImage/disk-image.qcow2"; fi
      qemu-img create -b "$origImage" -f qcow2 $diskImage
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
  });


  /* Create a filesystem image of the specified size and fill it with
     a set of RPM packages. */
    
  fillDiskWithRPMs =
    {size ? 4096, rpms, name, fullName, preInstall ? "", postInstall ? "", runScripts ? true}:
    
    runInLinuxVM (stdenv.mkDerivation {
      inherit name preInstall postInstall rpms;

      preVM = createEmptyImage {inherit size fullName;};

      buildCommand = ''
        ${createRootFS}

        chroot=$(type -tP chroot)
        
        echo "unpacking RPMs..."
        for i in $rpms; do
            echo "$i..."
            ${rpm}/bin/rpm2cpio "$i" | (cd /mnt && ${cpio}/bin/cpio -i --make-directories)
        done

        eval "$preInstall"

        echo "initialising RPM DB..."
        PATH=/usr/bin:/bin:/usr/sbin:/sbin $chroot /mnt \
          ldconfig -v || true
        PATH=/usr/bin:/bin:/usr/sbin:/sbin $chroot /mnt \
          rpm --initdb

        # Make the Nix store available in /mnt, because that's where the RPMs live.
        mkdir -p /mnt/nix/store
        ${utillinux}/bin/mount -o bind /nix/store /mnt/nix/store
        ${utillinux}/bin/mount -o bind /tmp /mnt/tmp
        
        echo "installing RPMs..."
        PATH=/usr/bin:/bin:/usr/sbin:/sbin $chroot /mnt \
          rpm -iv ${if runScripts then "" else "--noscripts"} $rpms

        echo "running post-install script..."
        eval "$postInstall"
        
        rm /mnt/.debug
        
        ${utillinux}/bin/umount /mnt/nix/store
        ${utillinux}/bin/umount /mnt/tmp
        ${utillinux}/bin/umount /mnt
      '';

      passthru = {inherit fullName;};
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
      qemu-img create -b ${image}/disk-image.qcow2 -f qcow2 "$diskImage"
    fi
    export TMPDIR=$(mktemp -d)
    export out=/dummy
    export origBuilder=
    export origArgs=
    export > $TMPDIR/saved-env
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
      stripHash "$src"
      srcName="$strippedName"
      cp "$src" "$srcName" # `ln' doesn't work always work: RPM requires that the file is owned by root

      export HOME=/tmp/home
      mkdir $HOME

      rpmout=/tmp/rpmout
      mkdir $rpmout $rpmout/SPECS $rpmout/BUILD $rpmout/RPMS $rpmout/SRPMS

      echo "%_topdir $rpmout" >> $HOME/.rpmmacros
      
      rpmbuild -vv -ta "$srcName"

      eval "$postBuild"
    '';

    installPhase = ''
      eval "$preInstall"
    
      ensureDir $out/$outDir
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
    {size ? 4096, debs, name, fullName, postInstall ? null}:
    
    runInLinuxVM (stdenv.mkDerivation {
      inherit name postInstall;

      debs = (lib.intersperse "|" debs);

      preVM = createEmptyImage {inherit size fullName;};

      buildCommand = ''
        ${createRootFS}

        PATH=$PATH:${dpkg}/bin:${dpkg}/sbin:${glibc}/sbin:${lzma}/bin

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
        mkdir -p /mnt/inst/nix/store
        ${utillinux}/bin/mount -o bind /nix/store /mnt/inst/nix/store
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
          PATH=/usr/bin:/bin:/usr/sbin:/sbin $chroot /mnt \
            /usr/bin/dpkg --install --force-all $debs < /dev/null
        done
        
        echo "running post-install script..."
        eval "$postInstall"
        ln -sf dash /mnt/bin/sh

        rm /mnt/.debug
        
        ${utillinux}/bin/umount /mnt/inst/nix/store
        ${utillinux}/bin/umount /mnt/proc
        ${utillinux}/bin/umount /mnt/dev
        ${utillinux}/bin/umount /mnt
      '';

      passthru = {inherit fullName;};
    });


  /* Generate a Nix expression containing fetchurl calls for the
     closure of a set of top-level RPM packages from the
     `primary.xml.gz' file of a Fedora or openSUSE distribution. */
     
  rpmClosureGenerator =
    {name, packagesList, urlPrefix, packages, archs ? []}:
    
    runCommand "${name}.nix" {buildInputs = [perl perlPackages.XMLSimple]; inherit archs;} ''
      gunzip < ${packagesList} > ./packages.xml
      perl -w ${rpm/rpm-closure.pl} \
        ./packages.xml ${urlPrefix} ${toString packages} > $out
    '';


  /* Helper function that combines rpmClosureGenerator and
     fillDiskWithRPMs to generate a disk image from a set of package
     names. */
     
  makeImageFromRPMDist =
    { name, fullName, size ? 4096, urlPrefix, packagesList, packages
    , preInstall ? "", postInstall ? "", archs ? ["noarch" "i386"], runScripts ? true}:

    fillDiskWithRPMs {
      inherit name fullName size preInstall postInstall runScripts;
      rpms = import (rpmClosureGenerator {
        inherit name packagesList urlPrefix packages archs;
      }) {inherit fetchurl;};
    };


  /* Like `rpmClosureGenerator', but now for Debian/Ubuntu releases
     (i.e. generate a closure from a Packages.bz2 file). */

  debClosureGenerator =
    {name, packagesList, urlPrefix, packages}:
    
    runCommand "${name}.nix" {} ''
      bunzip2 < ${packagesList} > ./Packages

      # Work around this bug: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=452279
      substituteInPlace ./Packages --replace x86_64-linux-gnu x86-64-linux-gnu

      ${perl}/bin/perl -I${dpkg} -w ${deb/deb-closure.pl} \
        ./Packages ${urlPrefix} ${toString packages} > $out
    '';
  

  /* Helper function that combines debClosureGenerator and
     fillDiskWithDebs to generate a disk image from a set of package
     names. */
     
  makeImageFromDebDist =
    {name, fullName, size ? 4096, urlPrefix, packagesList, packages, postInstall ? ""}:

    let
      expr = debClosureGenerator {
        inherit name packagesList urlPrefix packages;
      };
    in
      (fillDiskWithDebs {
        inherit name fullName size postInstall;
        debs = import expr {inherit fetchurl;};
      }) // {inherit expr;};


  /* A bunch of functions that build disk images of various Linux
     distributions, given a set of top-level package names to be
     installed in the image. */

  diskImageFuns = {

    fedora2i386 = args: makeImageFromRPMDist ({
      name = "fedora-core-2-i386";
      fullName = "Fedora Core 2 (i386)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/core/2/i386/os/repodata/primary.xml.gz;
        sha256 = "1nq1k2k0nzkii737cka301f0vbd2ix2wsfvi6bblpi748q6h2w4k";
      };
      urlPrefix = mirror://fedora/linux/core/2/i386/os;
      runScripts = false;
    } // args);
    
    fedora3i386 = args: makeImageFromRPMDist ({
      name = "fedora-core-3-i386";
      fullName = "Fedora Core 3 (i386)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/core/3/i386/os/repodata/primary.xml.gz;
        sha256 = "13znspn4g1bkjkk47393k9chswgzl6nx1n0q6h2wrw52c7d9nw9i";
      };
      urlPrefix = mirror://fedora/linux/core/3/i386/os;
      archs = ["noarch" "i386" "i586"];
      runScripts = false;
    } // args);
    
    fedora5i386 = args: makeImageFromRPMDist ({
      name = "fedora-core-5-i386";
      fullName = "Fedora Core 5 (i386)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/core/5/i386/os/repodata/primary.xml.gz;
        sha256 = "0lfk4mzrpiyls8h7k9ckc3vgywbmg05zsr4ag6qakgnv9gljijig";
      };
      urlPrefix = mirror://fedora/linux/core/5/i386/os;
    } // args);
    
    fedora7i386 = args: makeImageFromRPMDist ({
      name = "fedora-7-i386";
      fullName = "Fedora 7 (i386)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/7/Fedora/i386/os/repodata/primary.xml.gz;
        sha256 = "0zq7ifirj45wry7b2qkm12qhzzazal3hn610h5kwbrfr2xavs882";
      };
      urlPrefix = mirror://fedora/linux/releases/7/Fedora/i386/os;
    } // args);
    
    fedora8i386 = args: makeImageFromRPMDist ({
      name = "fedora-8-i386";
      fullName = "Fedora 8 (i386)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/8/Fedora/i386/os/repodata/primary.xml.gz;
        sha256 = "0vr9345rrk0vhs4pc9cjp8npdkqz0xqyirv84vhyfn533m9ws36f";
      };
      urlPrefix = mirror://fedora/linux/releases/8/Fedora/i386/os;
    } // args);

    fedora9i386 = args: makeImageFromRPMDist ({
      name = "fedora-9-i386";
      fullName = "Fedora 9 (i386)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/9/Fedora/i386/os/repodata/primary.xml.gz;
        sha256 = "18780xgyag5acx79warcpvzlfkm0mni8xawl6jjvgxg9n3lp6zg0";
      };
      urlPrefix = mirror://fedora/linux/releases/9/Fedora/i386/os;
    } // args);

    fedora9x86_64 = args: makeImageFromRPMDist ({
      name = "fedora-9-x86_64";
      fullName = "Fedora 9 (x86_64)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/9/Fedora/x86_64/os/repodata/primary.xml.gz;
        sha256 = "0qcjigzbw29ahhkfjaw5pbpyl7mj9l349hikwv25jcnid1cbpmx7";
      };
      urlPrefix = mirror://fedora/linux/releases/9/Fedora/x86_64/os;
      archs = ["noarch" "x86_64"];
    } // args);

    fedora10i386 = args: makeImageFromRPMDist ({
      name = "fedora-10-i386";
      fullName = "Fedora 10 (i386)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/10/Fedora/i386/os/repodata/primary.xml.gz;
        sha256 = "15ha8pxzvlch707mpy06c7pkr2ra2vpd5b8x30qhydvx8fgcqcx9";
      };
      urlPrefix = mirror://fedora/linux/releases/10/Fedora/i386/os;
    } // args);

    fedora10x86_64 = args: makeImageFromRPMDist ({
      name = "fedora-10-x86_64";
      fullName = "Fedora 10 (x86_64)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/10/Fedora/x86_64/os/repodata/primary.xml.gz;
        sha256 = "1pmaav6mdaw13fq99wfggbsmhcix306cimijjxh35qi7yc3wbsz4";
      };
      urlPrefix = mirror://fedora/linux/releases/10/Fedora/x86_64/os;
      archs = ["noarch" "x86_64"];
    } // args);

    fedora11i386 = args: makeImageFromRPMDist ({
      name = "fedora-11-i386";
      fullName = "Fedora 11 (i386)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/11/Fedora/i386/os/repodata/36af1d88214b770fd3d814a5126083b8e808510c76acfdc3a234d6f7e43c2425-primary.xml.gz;
        sha256 = "09947kjggmillb1zvb3n1i8his5qhdh1598lv39hyxsb4641vbrn";
      };
      urlPrefix = mirror://fedora/linux/releases/11/Fedora/i386/os;
      archs = ["noarch" "i386" "i586"];
    } // args);

    fedora11x86_64 = args: makeImageFromRPMDist ({
      name = "fedora-11-x86_64";
      fullName = "Fedora 11 (x86_64)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/11/Fedora/x86_64/os/repodata/c792495863f5314329c463d51860fc74c6367f72c3cb1c132f6c3290102d68da-primary.xml.gz;
        sha256 = "1nk85l890ckc5w9irjy3f9zkdiklzih1imb3qhll6cgmcdc4k4n7";
      };
      urlPrefix = mirror://fedora/linux/releases/11/Fedora/x86_64/os;
      archs = ["noarch" "x86_64"];
    } // args);

    fedora12i386 = args: makeImageFromRPMDist ({
      name = "fedora-12-i386";
      fullName = "Fedora 12 (i386)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/12/Fedora/i386/os/repodata/92857daf45687583ffa0fa6f8f97c71d08c50d8b6305dfeea8a3332bf2f7f27c-primary.xml.gz;
        sha256 = "0z7jyzr2ncx3m3pdy1b3ic6wa20xqybqyvzsl3zq6xb88nppv1cj";
      };
      urlPrefix = mirror://fedora/linux/releases/12/Fedora/i386/os;
      archs = ["noarch" "i386" "i586" "i686"];
    } // args);

    fedora12x86_64 = args: makeImageFromRPMDist ({
      name = "fedora-12-x86_64";
      fullName = "Fedora 12 (x86_64)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/12/Fedora/x86_64/os/repodata/a4ebee776b3c4898086e124a512e7f8c701ab1699fd83b2dcea3d7592b5c9ff0-primary.xml.gz;
        sha256 = "1w4zbhmmkmx3rqnkpn4zd6qilw4cgwp52jhjdq49hj1wddvyxsx4";
      };
      urlPrefix = mirror://fedora/linux/releases/12/Fedora/x86_64/os;
      archs = ["noarch" "x86_64"];
    } // args);

    fedora13i386 = args: makeImageFromRPMDist ({
      name = "fedora-13-i386";
      fullName = "Fedora 13 (i386)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/13/Fedora/i386/os/repodata/48c649978f695e8bf6214d16ff5413f8ab303976b33d0e96e0a5706e6f870682-primary.xml.gz;
        sha256 = "10h6hxpnww55w2b0wgdkfqwk1azq2dagy5jd47v8npk9iyblkij8";
      };
      urlPrefix = mirror://fedora/linux/releases/13/Fedora/i386/os;
      archs = ["noarch" "i386" "i586" "i686"];
    } // args);

    fedora13x86_64 = args: makeImageFromRPMDist ({
      name = "fedora-13-x86_64";
      fullName = "Fedora 13 (x86_64)";
      packagesList = fetchurl {
        url = mirror://fedora/linux/releases/13/Fedora/x86_64/os/repodata/ed88d22fca1c8bcc07d85bb677d5f8f45422a373a53b6dd213d57d7dfc278878-primary.xml.gz;
        sha256 = "0y484zy7szfm2g96sfx5ffij4m7lz3apgdjvv03wr2qwr8px527d";
      };
      urlPrefix = mirror://fedora/linux/releases/13/Fedora/x86_64/os;
      archs = ["noarch" "x86_64"];
    } // args);

    opensuse103i386 = args: makeImageFromRPMDist ({
      name = "opensuse-10.3-i586";
      fullName = "openSUSE 10.3 (i586)";
      packagesList = fetchurl {
        url = mirror://opensuse/distribution/10.3/repo/oss/suse/repodata/primary.xml.gz;
        sha256 = "0zb5kxsb755nqq9i8jdclmanacyf551ncx6a011v9jqphsvyfvd7";
      };
      urlPrefix = mirror://opensuse/distribution/10.3/repo/oss/suse/;
      archs = ["noarch" "i586"];
    } // args);

    opensuse110i386 = args: makeImageFromRPMDist ({
      name = "opensuse-11.0-i586";
      fullName = "openSUSE 11.0 (i586)";
      packagesList = fetchurl {
        url = mirror://opensuse/distribution/11.0/repo/oss/suse/repodata/primary.xml.gz;
        sha256 = "13rv855aj8p3h1zpsji5xa1wpkhgq94gcxzvg05l2b68b15q3mwn";
      };
      urlPrefix = mirror://opensuse/distribution/11.0/repo/oss/suse/;
      archs = ["noarch" "i586"];
    } // args);

    opensuse110x86_64 = args: makeImageFromRPMDist ({
      name = "opensuse-11.0-x86_64";
      fullName = "openSUSE 11.0 (x86_64)";
      packagesList = fetchurl {
        url = mirror://opensuse/distribution/11.0/repo/oss/suse/repodata/primary.xml.gz;
        sha256 = "13rv855aj8p3h1zpsji5xa1wpkhgq94gcxzvg05l2b68b15q3mwn";
      };
      urlPrefix = mirror://opensuse/distribution/11.0/repo/oss/suse/;
      archs = ["noarch" "x86_64"];
    } // args);

    opensuse111i386 = args: makeImageFromRPMDist ({
      name = "opensuse-11.1-i586";
      fullName = "openSUSE 11.1 (i586)";
      packagesList = fetchurl {
        url = mirror://opensuse/distribution/11.1/repo/oss/suse/repodata/primary.xml.gz;
        sha256 = "1mfmp9afikj0hci1s8cpwjdr0ycbpfym9gdhci590r9fa75w221j";
      };
      urlPrefix = mirror://opensuse/distribution/11.1/repo/oss/suse/;
      archs = ["noarch" "i586"];
    } // args);

    opensuse111x86_64 = args: makeImageFromRPMDist ({
      name = "opensuse-11.1-x86_64";
      fullName = "openSUSE 11.1 (x86_64)";
      packagesList = fetchurl {
        url = mirror://opensuse/distribution/11.1/repo/oss/suse/repodata/primary.xml.gz;
        sha256 = "1mfmp9afikj0hci1s8cpwjdr0ycbpfym9gdhci590r9fa75w221j";
      };
      urlPrefix = mirror://opensuse/distribution/11.1/repo/oss/suse/;
      archs = ["noarch" "x86_64"];
    } // args);

    # Interestingly, the SHA-256 hashes provided by Ubuntu in
    # http://nl.archive.ubuntu.com/ubuntu/dists/{gutsy,hardy}/Release are
    # wrong, but the SHA-1 and MD5 hashes are correct.  Intrepid is fine.

    ubuntu710i386 = args: makeImageFromDebDist ({
      name = "ubuntu-7.10-gutsy-i386";
      fullName = "Ubuntu 7.10 Gutsy (i386)";
      packagesList = fetchurl {
        url = mirror://ubuntu/dists/gutsy/main/binary-i386/Packages.bz2;
        sha1 = "8b52ee3d417700e2b2ee951517fa25a8792cabfd";
      };
      urlPrefix = mirror://ubuntu;
    } // args);
        
    ubuntu804i386 = args: makeImageFromDebDist ({
      name = "ubuntu-8.04-hardy-i386";
      fullName = "Ubuntu 8.04 Hardy (i386)";
      packagesList = fetchurl {
        url = mirror://ubuntu/dists/hardy/main/binary-i386/Packages.bz2;
        sha1 = "db74581ee75cb3bee2a8ae62364e97956c723259";
      };
      urlPrefix = mirror://ubuntu;
    } // args);
         
    ubuntu804x86_64 = args: makeImageFromDebDist ({
      name = "ubuntu-8.04-hardy-amd64";
      fullName = "Ubuntu 8.04 Hardy (amd64)";
      packagesList = fetchurl {
        url = mirror://ubuntu/dists/hardy/main/binary-amd64/Packages.bz2;
        sha1 = "d1f1d2b3cc62533d6e4337f2696a5d27235d1f28";
      };
      urlPrefix = mirror://ubuntu;
    } // args);
         
    ubuntu810i386 = args: makeImageFromDebDist ({
      name = "ubuntu-8.10-intrepid-i386";
      fullName = "Ubuntu 8.10 Intrepid (i386)";
      packagesList = fetchurl {
        url = mirror://ubuntu/dists/intrepid/main/binary-i386/Packages.bz2;
        sha256 = "70483d40a9e9b74598f2faede7df5d5103ee60055af7374f8db5c7e6017c4cf6";
      };
      urlPrefix = mirror://ubuntu;
    } // args);
 
    ubuntu810x86_64 = args: makeImageFromDebDist ({
      name = "ubuntu-8.10-intrepid-amd64";
      fullName = "Ubuntu 8.10 Intrepid (amd64)";
      packagesList = fetchurl {
        url = mirror://ubuntu/dists/intrepid/main/binary-amd64/Packages.bz2;
        sha256 = "01b2f3842cbdd5834446ddf91691bcf60f59a726dcefa23fb5b93fdc8ea7e27f";
      };
      urlPrefix = mirror://ubuntu;
    } // args);

    ubuntu904i386 = args: makeImageFromDebDist ({
      name = "ubuntu-9.04-jaunty-i386";
      fullName = "Ubuntu 9.04 Jaunty (i386)";
      packagesList = fetchurl {
        url = mirror://ubuntu/dists/jaunty/main/binary-i386/Packages.bz2;
        sha256 = "72c95e4901ad56ce8791723e2ae40bce2399f306f9956cac80e964011e1948d0";
      };
      urlPrefix = mirror://ubuntu;
    } // args);
 
    ubuntu904x86_64 = args: makeImageFromDebDist ({
      name = "ubuntu-9.04-jaunty-amd64";
      fullName = "Ubuntu 9.04 Jaunty (amd64)";
      packagesList = fetchurl {
        url = mirror://ubuntu/dists/jaunty/main/binary-amd64/Packages.bz2;
        sha256 = "af760ce04e43f066b8938b1abdeff979a642f940515659ede44f7877ca358ca8";
      };
      urlPrefix = mirror://ubuntu;
    } // args);

    ubuntu910i386 = args: makeImageFromDebDist ({
      name = "ubuntu-9.10-karmic-i386";
      fullName = "Ubuntu 9.10 Karmic (i386)";
      packagesList = fetchurl {
        url = mirror://ubuntu/dists/karmic/main/binary-i386/Packages.bz2;
        sha256 = "6e3e813857496f2af6cd7e6ada06b3398fa067a7992c5fd7e8bd8fa92e3548b7";
      };
      urlPrefix = mirror://ubuntu;
    } // args);
 
    ubuntu910x86_64 = args: makeImageFromDebDist ({
      name = "ubuntu-9.10-karmic-amd64";
      fullName = "Ubuntu 9.10 Karmic (amd64)";
      packagesList = fetchurl {
        url = mirror://ubuntu/dists/karmic/main/binary-amd64/Packages.bz2;
        sha256 = "3a604fcb0c135eeb8b95da3e90a8fd4cfeff519b858cd3c9e62ea808cb9fec40";
      };
      urlPrefix = mirror://ubuntu;
    } // args);

    ubuntu1004i386 = args: makeImageFromDebDist ({
      name = "ubuntu-10.04-lucid-i386";
      fullName = "Ubuntu 10.04 Lucid (i386)";
      packagesList = fetchurl {
        url = mirror://ubuntu/dists/lucid/main/binary-i386/Packages.bz2;
        sha256 = "0e46596202a68caa754dfe0883f46047525309880c492cdd5e2d0970fcf626aa";
      };
      urlPrefix = mirror://ubuntu;
    } // args);
 
    ubuntu1004x86_64 = args: makeImageFromDebDist ({
      name = "ubuntu-10.04-lucid-amd64";
      fullName = "Ubuntu 10.04 Lucid (amd64)";
      packagesList = fetchurl {
        url = mirror://ubuntu/dists/lucid/main/binary-amd64/Packages.bz2;
        sha256 = "74a8f3192b0eda397d65316e0fa6cd34d5358dced41639e07d9f1047971bfef0";
      };
      urlPrefix = mirror://ubuntu;
    } // args);

    debian40i386 = args: makeImageFromDebDist ({
      name = "debian-4.0r9-etch-i386";
      fullName = "Debian 4.0r9 Etch (i386)";
      packagesList = fetchurl {
        url = mirror://debian/dists/etch/main/binary-i386/Packages.bz2;
        sha256 = "40eeeecc35e6895b6eb0bc601e38fe53fc985d1b1f3fea3766f34763d21f206f";
      };
      urlPrefix = mirror://debian;
    } // args);
        
    debian40x86_64 = args: makeImageFromDebDist ({
      name = "debian-4.0r9-etch-amd64";
      fullName = "Debian 4.0r9 Etch (amd64)";
      packagesList = fetchurl {
        url = mirror://debian/dists/etch/main/binary-amd64/Packages.bz2;
        sha256 = "cf1c4c7d72e0da45797b046011254d2bd83f5ecb7389c7f30d2561be3f5b2e49";
      };
      urlPrefix = mirror://debian;
    } // args);

    debian50i386 = args: makeImageFromDebDist ({
      name = "debian-5.0.4-lenny-i386";
      fullName = "Debian 5.0.4 Lenny (i386)";
      packagesList = fetchurl {
        url = mirror://debian/dists/lenny/main/binary-i386/Packages.bz2;
        sha256 = "6c5ca67fb401a5d29f02557c290bbaee35c457172d548583b510d49eadd0f9ff";
      };
      urlPrefix = mirror://debian;
    } // args);
        
    debian50x86_64 = args: makeImageFromDebDist ({
      name = "debian-5.0.4-lenny-amd64";
      fullName = "Debian 5.0.4 Lenny (amd64)";
      packagesList = fetchurl {
        url = mirror://debian/dists/lenny/main/binary-amd64/Packages.bz2;
        sha256 = "c3b660b861ed257e82293a350ab868c2ce566bc084d35cc66b7388a881eaf3c5";
      };
      urlPrefix = mirror://debian;
    } // args);

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
  commonDebianPackages = [
    "base-passwd"
    "dpkg"
    "libc6-dev"
    "perl"
    "sysvinit"
    "bash"
    "dash"
    "gzip"
    "bzip2"
    "tar"
    "grep"
    "findutils"
    "g++"
    "make"
    "curl"
    "patch"
    "diff"
    "locales"
    # Needed by checkinstall:
    "util-linux" 
    "file"
    "dpkg-dev"
    "pkg-config"
    # Needed because it provides /etc/login.defs, whose absence causes
    # the "passwd" post-installs script to fail.
    "login"
    # For shutting up some messages during some post-install scripts:
    "mktemp"
  ];


  # Ubuntu 9.10 no longer has sysvinit.
  karmicPackages = lib.filter (x: x != "sysvinit") commonDebianPackages;

  lucidPackages = (lib.filter (x: x != "sysvinit" && x != "diff") commonDebianPackages) ++ [ "diffutils" ];
  

  /* A bunch of disk images. */

  diskImages =

    { redhat9i386 = fillDiskWithRPMs {
        name = "redhat-9-i386";
        fullName = "Red Hat Linux 9 (i386)";
        size = 1024;
        rpms = import ./rpm/redhat-9-i386.nix {inherit fetchurl;};
     };
    
      suse90i386 = fillDiskWithRPMs {
        name = "suse-9.0-i386";
        fullName = "SUSE Linux 9.0 (i386)";
        size = 1024;
        rpms = import ./rpm/suse-9-i386.nix {inherit fetchurl;};
        # Urgh.  The /etc/group entries are installed by aaa_base (or
        # something) but due to dependency ordering, that package isn't
        # installed yet by the time some other packages refer to these
        # entries.
        preInstall = ''
          echo 'bin:x:1:daemon' >> /mnt/etc/group
          echo 'tty:x:5:' >> /mnt/etc/group
          echo 'disk:x:6:' >> /mnt/etc/group
          echo 'lp:x:7:' >> /mnt/etc/group
          echo 'uucp:x:14:' >> /mnt/etc/group
          echo 'audio:x:17:' >> /mnt/etc/group
          echo 'video:x:33:' >> /mnt/etc/group
        '';
      };

    } // lib.mapAttrs (name: f: f []) diskImageExtraFuns;
    

  diskImageExtraFuns = {
    fedora2i386 = extraVirtualPackages : diskImageFuns.fedora2i386 { packages = commonFedoraPackages ++ extraVirtualPackages; };
    fedora3i386 = extraVirtualPackages : diskImageFuns.fedora3i386 { packages = commonFedoraPackages ++ extraVirtualPackages; };
    fedora5i386 = extraVirtualPackages : diskImageFuns.fedora5i386 { packages = commonFedoraPackages ++ ["util-linux"] ++ extraVirtualPackages; };
    fedora7i386 = extraVirtualPackages : diskImageFuns.fedora7i386 { packages = commonFedoraPackages ++ extraVirtualPackages; };
    fedora8i386 = extraVirtualPackages : diskImageFuns.fedora8i386 { packages = commonFedoraPackages ++ extraVirtualPackages; };
    fedora9i386 = extraVirtualPackages : diskImageFuns.fedora9i386 { packages = commonFedoraPackages       ++ [ "cronie" "util-linux-ng" ] ++ extraVirtualPackages; };
    fedora9x86_64 = extraVirtualPackages : diskImageFuns.fedora9x86_64 { packages = commonFedoraPackages   ++ [ "cronie" "util-linux-ng" ] ++ extraVirtualPackages; };
    fedora10i386 = extraVirtualPackages : diskImageFuns.fedora10i386 { packages = commonFedoraPackages     ++ [ "cronie" "util-linux-ng" ] ++ extraVirtualPackages; };
    fedora10x86_64 = extraVirtualPackages : diskImageFuns.fedora10x86_64 { packages = commonFedoraPackages ++ [ "cronie" "util-linux-ng" ] ++ extraVirtualPackages; };
    fedora11i386 = extraVirtualPackages : diskImageFuns.fedora11i386 { packages = commonFedoraPackages     ++ [ "cronie" "util-linux-ng" ] ++ extraVirtualPackages; };
    fedora11x86_64 = extraVirtualPackages : diskImageFuns.fedora11x86_64 { packages = commonFedoraPackages ++ [ "cronie" "util-linux-ng" ] ++ extraVirtualPackages; };
    fedora12i386 = extraVirtualPackages : diskImageFuns.fedora12i386 { packages = commonFedoraPackages     ++ [ "cronie" "util-linux-ng" ] ++ extraVirtualPackages; };
    fedora12x86_64 = extraVirtualPackages : diskImageFuns.fedora12x86_64 { packages = commonFedoraPackages ++ [ "cronie" "util-linux-ng" ] ++ extraVirtualPackages; };
    fedora13i386 = extraVirtualPackages : diskImageFuns.fedora13i386 { packages = commonFedoraPackages     ++ [ "cronie" "util-linux-ng" ] ++ extraVirtualPackages; };
    fedora13x86_64 = extraVirtualPackages : diskImageFuns.fedora13x86_64 { packages = commonFedoraPackages ++ [ "cronie" "util-linux-ng" ] ++ extraVirtualPackages; };
    opensuse103i386 = extraVirtualPackages : diskImageFuns.opensuse103i386 { packages = commonOpenSUSEPackages ++ ["devs"] ++ extraVirtualPackages; };
    opensuse110i386 = extraVirtualPackages : diskImageFuns.opensuse110i386 { packages = commonOpenSUSEPackages ++ extraVirtualPackages; };
    opensuse110x86_64 = extraVirtualPackages : diskImageFuns.opensuse110x86_64 { packages = commonOpenSUSEPackages ++ extraVirtualPackages; };
    opensuse111i386 = extraVirtualPackages : diskImageFuns.opensuse111i386 { packages = commonOpenSUSEPackages ++ extraVirtualPackages; };
    opensuse111x86_64 = extraVirtualPackages : diskImageFuns.opensuse111x86_64 { packages = commonOpenSUSEPackages ++ extraVirtualPackages; };

    ubuntu710i386 = extraVirtualPackages : diskImageFuns.ubuntu710i386 { packages = commonDebianPackages ++ extraVirtualPackages; };
    ubuntu804i386 = extraVirtualPackages : diskImageFuns.ubuntu804i386 { packages = commonDebianPackages ++ extraVirtualPackages; };
    ubuntu804x86_64 = extraVirtualPackages : diskImageFuns.ubuntu804x86_64 { packages = commonDebianPackages ++ extraVirtualPackages; };
    ubuntu810i386 = extraVirtualPackages : diskImageFuns.ubuntu810i386 { packages = commonDebianPackages ++ extraVirtualPackages; };
    ubuntu810x86_64 = extraVirtualPackages : diskImageFuns.ubuntu810x86_64 { packages = commonDebianPackages ++ extraVirtualPackages; };
    ubuntu904i386 = extraVirtualPackages : diskImageFuns.ubuntu904i386 { packages = commonDebianPackages ++ extraVirtualPackages; };
    ubuntu904x86_64 = extraVirtualPackages : diskImageFuns.ubuntu904x86_64 { packages = commonDebianPackages ++ extraVirtualPackages; };
    ubuntu910i386 = extraVirtualPackages : diskImageFuns.ubuntu910i386 { packages = karmicPackages ++ extraVirtualPackages; };
    ubuntu910x86_64 = extraVirtualPackages : diskImageFuns.ubuntu910x86_64 { packages = karmicPackages ++ extraVirtualPackages; };
    ubuntu1004i386 = extraVirtualPackages : diskImageFuns.ubuntu1004i386 { packages = lucidPackages ++ extraVirtualPackages; };
    ubuntu1004x86_64 = extraVirtualPackages : diskImageFuns.ubuntu1004x86_64 { packages = lucidPackages ++ extraVirtualPackages; };
    debian40i386 = extraVirtualPackages : diskImageFuns.debian40i386 { packages = commonDebianPackages ++ extraVirtualPackages; };
    debian40x86_64 = extraVirtualPackages : diskImageFuns.debian40x86_64 { packages = commonDebianPackages ++ extraVirtualPackages; };
    debian50i386 = extraVirtualPackages : diskImageFuns.debian50i386 { packages = commonDebianPackages ++ extraVirtualPackages; };
    debian50x86_64 = extraVirtualPackages : diskImageFuns.debian50x86_64 { packages = commonDebianPackages ++ extraVirtualPackages; };
  };

}
