{pkgs}:

with pkgs;

rec {


  inherit (kernelPackages_2_6_26) kernel;

  klibcShrunk = pkgs.klibcShrunk.override { klibc = klibc_15; };


  modulesClosure = makeModulesClosure {
    inherit kernel;
    rootModules = ["cifs" "virtio_net" "virtio_pci" "virtio_blk" "virtio_balloon" "nls_utf8"];
  };


  # !!! should use the mount_cifs package in all-packages.nix here.
  mountCifs = (makeStaticBinaries stdenv).mkDerivation {
    name = "mount.cifs";
    src = mount_cifs.src;
    buildInputs = [nukeReferences];
    buildCommand = ''
      ensureDir $out/bin
      gcc -Wall $src -o $out/bin/mount.cifs
      strip $out/bin/mount.cifs
      nuke-refs $out/bin/mount.cifs
    '';
    allowedReferences = []; # prevent accidents like glibc being included in the initrd
  };


  createDeviceNodes = dev:
    ''
      mknod ${dev}/null c 1 3
      mknod ${dev}/zero c 1 5
      mknod ${dev}/tty  c 5 0
      mknod ${dev}/vda  b 253 0
    '';

  
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
    ${createDeviceNodes "/dev"}
    
    ipconfig 10.0.2.15:::::eth0:none

    mkdir /fs

    if test -z "$mountDisk"; then
      mount -t tmpfs none /fs
    else
      mount -t ext2 /dev/vda /fs
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


  qemuCommandLinux = ''
    qemu-system-x86_64 -no-kvm-irqchip \
      -nographic -no-reboot \
      -net nic,model=virtio -net user -smb / \
      -drive file=$diskImage,if=virtio,boot=on \
      -kernel ${kernel}/vmlinuz \
      -initrd ${initrd}/initrd \
      -append "console=ttyS0 panic=1 command=${stage2Init} tmpDir=$TMPDIR out=$out mountDisk=$mountDisk" \
      $QEMU_OPTS
  '';

  
  vmRunCommand = qemuCommand: writeText "vm-run" ''
    export > saved-env

    PATH=${coreutils}/bin:${kvm}/bin:${samba}/sbin

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
    ${e2fsprogs}/sbin/mke2fs -F /dev/vda
    ${klibcShrunk}/bin/mount -t ext2 /dev/vda /mnt

    if test -e /mnt/.debug; then
      exec ${bash}/bin/sh
    fi
    touch /mnt/.debug

    mkdir /mnt/proc /mnt/dev /mnt/sys /mnt/bin
    ${createDeviceNodes "/mnt/dev"}
  '';


  modifyDerivation = f: attrs:
    let attrsCleaned = removeAttrs attrs ["meta" "passthru" "outPath" "drvPath"];
        newDrv = derivation (attrsCleaned // (f attrs));
    in newDrv //
      { meta = if attrs ? meta then attrs.meta else {};
        passthru = if attrs ? passthru then attrs.passthru else {};
      };


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
     
  runInLinuxVM = modifyDerivation (attrs: {
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
  runInGenericVM = modifyDerivation (attrs: {
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
        ${klibcShrunk}/bin/mount -o bind /nix/store /mnt/nix/store
        
        echo "installing RPMs..."
        PATH=/usr/bin:/bin:/usr/sbin:/sbin $chroot /mnt \
          rpm -iv ${if runScripts then "" else "--noscripts"} $rpms

        echo "running post-install script..."
        eval "$postInstall"
        
        rm /mnt/.debug
        
        ${klibcShrunk}/bin/umount /mnt/nix/store
        ${klibcShrunk}/bin/umount /mnt
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
        rpm -iv $extraRPMs
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
        
        rm /mnt/.debug
        
        ${klibcShrunk}/bin/umount /mnt/inst/nix/store
        ${klibcShrunk}/bin/umount /mnt/dev
        ${klibcShrunk}/bin/umount /mnt
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
        sha256 = "adc46fec04a5d87571c60fa1a29dfb73ca69ad6eb0276615b28595a3f06988e1";
      };
      urlPrefix = mirror://ubuntu;
    } // args);

    debian40i386 = args: makeImageFromDebDist ({
      name = "debian-4.0r8-etch-i386";
      fullName = "Debian 4.0r8 Etch (i386)";
      packagesList = fetchurl {
        url = mirror://debian/dists/etch/main/binary-i386/Packages.bz2;
        sha256 = "80ea57a7f106086c74470229998b07885d185dc62fe4a3200d2fffc5b2371f3d";
      };
      urlPrefix = mirror://debian;
    } // args);
        
    debian40x86_64 = args: makeImageFromDebDist ({
      name = "debian-4.0r8-etch-amd64";
      fullName = "Debian 4.0r8 Etch (amd64)";
      packagesList = fetchurl {
        url = mirror://debian/dists/etch/main/binary-amd64/Packages.bz2;
        sha256 = "d00114ef5e0c287273eebff7e7c4ca1aa0388a56c7d980a0a031e7782741e5ba";
      };
      urlPrefix = mirror://debian;
    } // args);

    debian50i386 = args: makeImageFromDebDist ({
      name = "debian-5.0.1-lenny-i386";
      fullName = "Debian 5.0.1 Lenny (i386)";
      packagesList = fetchurl {
        url = mirror://debian/dists/lenny/main/binary-i386/Packages.bz2;
        sha256 = "a8257890a83302ebe8e4413cbec83bea1ac6b7345646465566d625d70558aeb6";
      };
      urlPrefix = mirror://debian;
    } // args);
        
    debian50x86_64 = args: makeImageFromDebDist ({
      name = "debian-5.0.1-lenny-amd64";
      fullName = "Debian 5.0.1 Lenny (amd64)";
      packagesList = fetchurl {
        url = mirror://debian/dists/lenny/main/binary-amd64/Packages.bz2;
        sha256 = "6812c7462f4b2b767c157d01139e0fc9e17f99c492dcc59361dbd48ed8ec0e63";
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


  /* A bunch of disk images. */

  diskImages = {

    redhat9i386 = fillDiskWithRPMs {
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
    
    fedora2i386 = diskImageFuns.fedora2i386 { packages = commonFedoraPackages; };
    fedora3i386 = diskImageFuns.fedora3i386 { packages = commonFedoraPackages; };
    fedora5i386 = diskImageFuns.fedora5i386 { packages = commonFedoraPackages ++ ["util-linux"]; };
    fedora7i386 = diskImageFuns.fedora7i386 { packages = commonFedoraPackages; };
    fedora8i386 = diskImageFuns.fedora8i386 { packages = commonFedoraPackages; };
    fedora9i386 = diskImageFuns.fedora9i386 { packages = commonFedoraPackages       ++ [ "cronie" "util-linux-ng" ]; };
    fedora9x86_64 = diskImageFuns.fedora9x86_64 { packages = commonFedoraPackages   ++ [ "cronie" "util-linux-ng" ]; };
    fedora10i386 = diskImageFuns.fedora10i386 { packages = commonFedoraPackages     ++ [ "cronie" "util-linux-ng" ]; };
    fedora10x86_64 = diskImageFuns.fedora10x86_64 { packages = commonFedoraPackages ++ [ "cronie" "util-linux-ng" ]; };
    fedora11i386 = diskImageFuns.fedora11i386 { packages = commonFedoraPackages     ++ [ "cronie" "util-linux-ng" ]; };
    fedora11x86_64 = diskImageFuns.fedora11x86_64 { packages = commonFedoraPackages ++ [ "cronie" "util-linux-ng" ]; };
    opensuse103i386 = diskImageFuns.opensuse103i386 { packages = commonOpenSUSEPackages ++ ["devs"]; };
    opensuse110i386 = diskImageFuns.opensuse110i386 { packages = commonOpenSUSEPackages; };
    opensuse110x86_64 = diskImageFuns.opensuse110x86_64 { packages = commonOpenSUSEPackages; };
    
    ubuntu710i386 = diskImageFuns.ubuntu710i386 { packages = commonDebianPackages; };
    ubuntu804i386 = diskImageFuns.ubuntu804i386 { packages = commonDebianPackages; };
    ubuntu804x86_64 = diskImageFuns.ubuntu804x86_64 { packages = commonDebianPackages; };
    ubuntu810i386 = diskImageFuns.ubuntu810i386 { packages = commonDebianPackages; };
    ubuntu810x86_64 = diskImageFuns.ubuntu810x86_64 { packages = commonDebianPackages; };
    ubuntu904i386 = diskImageFuns.ubuntu904i386 { packages = commonDebianPackages; };
    ubuntu904x86_64 = diskImageFuns.ubuntu904x86_64 { packages = commonDebianPackages; };
    debian40i386 = diskImageFuns.debian40i386 { packages = commonDebianPackages; };
    debian40x86_64 = diskImageFuns.debian40x86_64 { packages = commonDebianPackages; };
    debian50i386 = diskImageFuns.debian50i386 { packages = commonDebianPackages; };
    debian50x86_64 = diskImageFuns.debian50x86_64 { packages = commonDebianPackages; };

  };


}
