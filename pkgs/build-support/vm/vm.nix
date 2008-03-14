with import ../../nixpkgs {};

rec {

  stdenvLinuxStuff = import ../../nixpkgs/pkgs/stdenv/linux {
    system = stdenv.system;
    allPackages = import ../../nixpkgs/pkgs/top-level/all-packages.nix;
  };

  
  modulesClosure = import ../../nixos/helpers/modules-closure.nix {
    inherit stdenv module_init_tools kernel;
    #rootModules = ["cifs" "ne2k_pci" "nls_utf8" "ata_piix" "sd_mod"];
    rootModules = ["cifs" "ne2k_pci" "nls_utf8" "ide_disk" "ide_generic"];
  };

  
  klibcShrunk = stdenv.mkDerivation {
    name = "${klibc.name}";
    buildCommand = ''
      ensureDir $out/lib
      cp -prd ${klibc}/lib/klibc/bin $out/
      cp -p ${klibc}/lib/*.so $out/lib/
      chmod +w $out/*
      old=$(echo ${klibc}/lib/klibc-*.so)
      new=$(echo $out/lib/klibc-*.so)
      for i in $out/bin/*; do
        echo $i
        sed "s^$old^$new^" -i $i
        # !!! use patchelf
        #patchelf --set-rpath /foo/bar $i
      done
    ''; # */
    allowedReferences = ["out"];
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
    #! ${stdenvLinuxStuff.bootstrapTools.bash} -e
    echo START

    export PATH=${klibcShrunk}/bin:${mountCifs}/bin

    mkdir /etc
    echo -n > /etc/fstab

    mount -t proc none /proc

    for o in $(cat /proc/cmdline); do
      case $o in
        useTmpRoot=1)
          useTmpRoot=1
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

    if test -n "$useTmpRoot"; then
      mount -t tmpfs none /fs
    else
      mount -t ext2 /dev/hda /fs
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

  
  initrd = import ../../nixos/boot/make-initrd.nix {
    inherit stdenv perl cpio;
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
      -append "console=ttyS0 panic=1 command=${stage2Init} tmpDir=$TMPDIR out=$out useTmpRoot=$useTmpRoot" \
      $QEMU_OPTS
  '';

  
  vmRunCommand = writeText "vm-run" ''
    export > saved-env

    PATH=${coreutils}/bin:${kvm}/bin

    diskImage=/dev/null

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

  
  # Modify the given derivation to perform it in a virtual machine.
  runInLinuxVM = attrs: derivation (removeAttrs attrs ["meta" "passthru" "outPath" "drvPath"] // {
    builder = "${bash}/bin/sh";
    args = ["-e" vmRunCommand];
    origArgs = attrs.args;
    origBuilder = attrs.builder;
    QEMU_OPTS = "-m ${toString (if attrs ? memSize then attrs.memSize else 256)}";
  });

  
  test = runInLinuxVM patchelf;


  fillDiskWithRPMs =
    {size ? 1024, rpms, name, fullName, postInstall ? null}:
    
    runInLinuxVM (stdenv.mkDerivation {
      inherit name postInstall rpms;

      useTmpRoot = true;
    
      preVM = ''
        mkdir $out
        diskImage=$out/image
        qemu-img create -f qcow $diskImage "${toString size}M"
      '';

      buildCommand = ''
        mkdir /mnt
        ${e2fsprogs}/sbin/mke2fs -F /dev/hda
        ${klibcShrunk}/bin/mount -t ext2 /dev/hda /mnt

        mkdir /mnt/proc /mnt/dev /mnt/sys

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
        
        ${klibcShrunk}/bin/umount /mnt
      '';
    });


  test2 = fillDiskWithRPMs {
    size = 1024;
    name = "test";
    fullName = "Test Image";
    rpms = import ../rpm/fedora-3-packages.nix {inherit fetchurl;};
  };


  # Generates a script that can be used to run an interactive session
  # in the given image.
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

  test3 = makeImageTestScript test2;


  buildRPM = runInLinuxVM (stdenv.mkDerivation {
    name = "rpm-test";
  
    preVM = ''
      diskImage=$(pwd)/image
      qemu-img create -b ${test2}/image -f qcow $diskImage
    '';

    src = patchelf.src;

    buildCommand = ''
      PATH=/usr/bin:/bin:/usr/sbin:/sbin

      echo ${patchelf.src}

      stripHash "$src"
      srcName="$strippedName"
      ln -s "$src" "$srcName"

      rpmbuild -vv -ta "$srcName"

      ensureDir $out/rpms
      find /usr/src -name "*.rpm" -exec cp {} $out/rpms \;
    '';
  });


  # !!! should probably merge this with fillDiskWithRPMs.
  fillDiskWithDebs =
    {size ? 1024, debs, name, fullName, postInstall ? null}:
    
    runInLinuxVM (stdenv.mkDerivation {
      inherit name postInstall;

      debs = (lib.intersperse "|" debs);

      useTmpRoot = true;
    
      preVM = ''
        mkdir $out
        diskImage=$out/image
        qemu-img create -f qcow $diskImage "${toString size}M"
      '';

      buildCommand = ''
        mkdir /mnt
        ${e2fsprogs}/sbin/mke2fs -F /dev/hda
        ${klibcShrunk}/bin/mount -t ext2 /dev/hda /mnt

        if test -e /mnt/.debug; then
          exec ${bash}/bin/sh
        fi
        touch /mnt/.debug

        mkdir /mnt/proc /mnt/dev /mnt/sys /mnt/bin

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


  test4 = fillDiskWithDebs {
    size = 256;
    name = "deb-test";
    fullName = "Ubuntu Test Image";
    debs = import ./deb/ubuntu-7.10-gutsy-i386.nix {inherit fetchurl;};
  };

  test5 = makeImageTestScript test4;

  
  test6 = runInLinuxVM (stdenv.mkDerivation {
    name = "deb-compile";
  
    preVM = ''
      diskImage=$(pwd)/image
      qemu-img create -b ${test7}/image -f qcow $diskImage
    '';

    src = nixUnstable.src;

    postHook = ''
      PATH=/usr/bin:/bin:/usr/sbin:/sbin
      SHELL=/bin/sh
    '';

    fixupPhase = "true";

    memSize = 512;
  });
  

  test7 = fillDiskWithDebs {
    size = 256;
    name = "deb-test";
    fullName = "Debian Test Image";
    debs = import ./deb/debian-4.0r3-etch-i386.nix {inherit fetchurl;};
  };

  
}
