{pkgs}:

with pkgs;

rec {


  modulesClosure = makeModulesClosure {
    inherit kernel;
    rootModules = ["cifs" "ne2k_pci" "nls_utf8" "ata_piix" "sd_mod"];
  };

  
  mountCifs = (makeStaticBinaries stdenv).mkDerivation {
    name = "mount.cifs";
    src = fetchurl {
      name = "mount.cifs.c";
      url = "http://websvn.samba.org/cgi-bin/viewcvs.cgi/*checkout*/branches/SAMBA_3_0/source/client/mount.cifs.c?rev=6103";
      sha256 = "19205gd3pv8g519hlbjaw559wqgf0h2vkln9xgqaqip2h446qarp";
    };
    buildInputs = [nukeReferences];
    buildCommand = ''
      ensureDir $out/bin
      gcc -Wall $src -o $out/bin/mount.cifs
      strip $out/bin/mount.cifs
      nuke-refs $out/bin/mount.cifs
    '';
    allowedReferences = []; # prevent accidents like glibc being included in the initrd
  };

  
  stage1Init = writeScript "vm-run-stage1" ''
    #! ${klibcShrunk}/bin/sh.shared -e
    echo START

    export PATH=${klibcShrunk}/bin:${mountCifs}/bin

    mkdir /etc
    echo -n > /etc/fstab

    mount -t proc none /proc

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
      echo "loading module $i with args $args"
      insmod $i $args
    done

    mount -t tmpfs none /dev
    mknod /dev/null c 1 3
    mknod /dev/zero c 1 5
    mknod /dev/tty  c 5 0
    mknod /dev/sda  b 8 0
    mknod /dev/hda  b 3 0
    
    ipconfig 10.0.2.15:::::eth0:none

    mkdir /fs

    if test -z "$mountDisk"; then
      mount -t tmpfs none /fs
    else
      mount -t ext2 /dev/sda /fs
    fi
    
    mkdir -p /fs/hostfs
    
    mkdir -p /fs/dev
    mount -o bind /dev /fs/dev

    mount.cifs //10.0.2.4/qemu /fs/hostfs -o guest,username=nobody

    mkdir -p /fs/nix/store
    mount -o bind /fs/hostfs/nix/store /fs/nix/store
    
    mkdir -p /fs/tmp
    mount -t tmpfs -o "mode=755" none /fs/tmp

    mkdir -p /fs/proc
    mount -t proc none /fs/proc

    mkdir -p /fs/etc
    ln -sf /proc/mounts /fs/etc/mtab
    
    echo "Now running: $command"
    test -n "$command"

    set +e
    chroot /fs $command /tmp $out /hostfs/$tmpDir
    echo $? > /fs/hostfs/$tmpDir/in-vm-exit

    mount -o remount,ro dummy /fs

    echo DONE
    reboot
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


  qemuCommand = ''
    QEMU_SMBD_COMMAND=${samba}/sbin/smbd qemu-system-x86_64 \
      -nographic -no-reboot \
      -smb / -hda $diskImage \
      -kernel ${kernel}/vmlinuz \
      -initrd ${initrd}/initrd \
      -append "console=ttyS0 panic=1 command=${stage2Init} tmpDir=$TMPDIR out=$out mountDisk=$mountDisk" \
      $QEMU_OPTS
  '';

  
  vmRunCommand = writeText "vm-run" ''
    export > saved-env

    PATH=${coreutils}/bin:${kvm}/bin

    diskImage=''${diskImage:-/dev/null}

    eval "$preVM"

    # Write the command to start the VM to a file so that the user can
    # debug inside the VM if the build fails (when Nix is called with
    # the -K option to preserve the temporary build directory).
    cat > ./run-vm <<EOF
    #! ${bash}/bin/sh
    diskImage=$diskImage
    TMPDIR=$TMPDIR
    ${qemuCommand}
    EOF

    chmod +x ./run-vm
    source ./run-vm
    
    if ! test -e in-vm-exit; then
      echo "Virtual machine didn't produce an exit code."
      exit 1
    fi
    
    exit $(cat in-vm-exit)
  '';


  createEmptyImage = {size, fullName}: ''
    mkdir $out
    diskImage=$out/image
    qemu-img create -f qcow $diskImage "${toString size}M"

    mkdir $out/nix-support
    echo "${fullName}" > $out/nix-support/full-name
  '';


  createRootFS = ''
    mkdir /mnt
    ${e2fsprogs}/sbin/mke2fs -F /dev/sda
    ${klibcShrunk}/bin/mount -t ext2 /dev/sda /mnt

    if test -e /mnt/.debug; then
      exec ${bash}/bin/sh
    fi
    touch /mnt/.debug

    mkdir /mnt/proc /mnt/dev /mnt/sys /mnt/bin
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
     
  runInLinuxVM = attrs: derivation (removeAttrs attrs ["meta" "passthru" "outPath" "drvPath"] // {
    builder = "${bash}/bin/sh";
    args = ["-e" vmRunCommand];
    origArgs = attrs.args;
    origBuilder = attrs.builder;
    QEMU_OPTS = "-m ${toString (if attrs ? memSize then attrs.memSize else 256)}";
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
      diskImage=$(pwd)/image
      origImage=${attrs.diskImage}
      if test -d "$origImage"; then origImage="$origImage/image"; fi
      qemu-img create -b "$origImage" -f qcow $diskImage
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
    {size ? 1024, rpms, name, fullName, postInstall ? null}:
    
    runInLinuxVM (stdenv.mkDerivation {
      inherit name postInstall rpms;

      preVM = createEmptyImage {inherit size fullName;};

      buildCommand = ''
        ${createRootFS}

        echo "initialising RPM DB..."
        rpm="${rpm}/bin/rpm --root /mnt --dbpath /var/lib/rpm"
        $rpm --initdb

        echo "installing RPMs..."
        $rpm --noscripts --notriggers --nodeps -iv $rpms

        # Get rid of the Berkeley DB environment so that older RPM versions
        # (using older versions of BDB) will still work.
        rm -f /mnt/var/lib/rpm/__db.*

        if test -e /mnt/bin/rpm; then
          chroot /mnt /bin/rpm --rebuilddb
        fi

        chroot /mnt /sbin/ldconfig

        echo "running post-install script..."
        eval "$postInstall"
        
        rm /mnt/.debug
        
        ${klibcShrunk}/bin/umount /mnt
      '';
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
      qemu-img create -b ${image}/image -f qcow "$diskImage"
    fi
    export TMPDIR=$(mktemp -d)
    export out=/dummy
    export origBuilder=
    export origArgs=
    export > $TMPDIR/saved-env
    ${qemuCommand}
  '';


  /* Build RPM packages from the tarball `src' in the Linux
     distribution installed in the filesystem `diskImage'.  The
     tarball must contain an RPM specfile. */
  
  buildRPM = attrs: runInLinuxImage (stdenv.mkDerivation (attrs // {
    phases = "sysInfoPhase buildPhase installPhase";
  
    sysInfoPhase = ''
      header "base RPMs"
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

      rpmbuild -vv -ta "$srcName" || fail

      eval "$postBuild"
    '';

    installPhase = ''
      ensureDir $out/rpms
      find /usr/src -name "*.rpm" -exec cp {} $out/rpms \;

      for i in $out/rpms/*.rpm; do
        header "Generated RPM/SRPM: $i"
        rpm -qip $i
        stopNest
      done
    '';
  }));


  /* Create a filesystem image of the specified size and fill it with
     a set of Debian packages.  `debs' must be a list of list of
     .deb files, namely, the Debian packages grouped together into
     strongly connected components.  See deb/deb-closure.nix. */

  fillDiskWithDebs =
    {size ? 1024, debs, name, fullName, postInstall ? null}:
    
    runInLinuxVM (stdenv.mkDerivation {
      inherit name postInstall;

      debs = (lib.intersperse "|" debs);

      preVM = createEmptyImage {inherit size fullName;};

      buildCommand = ''
        ${createRootFS}

        echo "initialising Debian DB..."
        PATH=$PATH:${dpkg}/bin:${dpkg}/sbin:${glibc}/sbin

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
        ${klibcShrunk}/bin/mount -o bind /nix/store /mnt/inst/nix/store

        ${klibcShrunk}/bin/mount -o bind /dev /mnt/dev
        
        # Misc. files/directories assumed by various packages.
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
        
        rm /mnt/.debug
        
        ${klibcShrunk}/bin/umount /mnt/inst/nix/store
        ${klibcShrunk}/bin/umount /mnt/dev
        ${klibcShrunk}/bin/umount /mnt
      '';
    });


  /* A bunch of disk images. */

  diskImages = {

    redhat9i386 = fillDiskWithRPMs {
      name = "redhat-9-i386-image";
      fullName = "Red Hat Linux 9 (i386)";
      size = 768;
      rpms = import ./rpm/redhat-9-i386.nix {inherit fetchurl;};
    };
    
    suse90i386 = fillDiskWithRPMs {
      name = "suse-9.0-i386-image";
      fullName = "SUSE Linux 9.0 (i386)";
      size = 768;
      rpms = import ./rpm/suse-9-i386.nix {inherit fetchurl;};
    };
    
    fedora2i386 = fillDiskWithRPMs {
      name = "fedora-core-2-i386-image";
      fullName = "Fedora Core 2 (i386)";
      size = 768;
      rpms = import ./rpm/fedora-2-i386.nix {inherit fetchurl;};
    };
    
    fedora3i386 = fillDiskWithRPMs {
      name = "fedora-core-3-i386-image";
      fullName = "Fedora Core 3 (i386)";
      size = 768;
      rpms = import ./rpm/fedora-3-i386.nix {inherit fetchurl;};
    };
    
    fedora5i386 = fillDiskWithRPMs {
      name = "fedora-core-5-i386-image";
      fullName = "Fedora Core 5 (i386)";
      size = 768;
      rpms = import ./rpm/fedora-5-i386.nix {inherit fetchurl;};
    };
    
    ubuntu710i386 = fillDiskWithDebs {
      name = "ubuntu-7.10-gutsy-i386-image";
      fullName = "Ubuntu 7.10 Gutsy (i386)";
      size = 512;
      debs = import ./deb/ubuntu-7.10-gutsy-i386.nix {inherit fetchurl;};
    };

    debian40r3i386 = fillDiskWithDebs {
      name = "debian-4.0r3-etch-i386-image";
      fullName = "Debian 4.0r3 Etch (i386)";
      size = 512;
      debs = import ./deb/debian-4.0r3-etch-i386.nix {inherit fetchurl;};
    };

  };

}
