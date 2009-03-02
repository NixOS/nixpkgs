# This function compiles a source tarball in a virtual machine image
# that contains a Debian-like (i.e. dpkg-based) OS.

{ name ? "debian-build"
, diskImage
, src, stdenv, vmTools, checkinstall
, ... } @ args:

vmTools.runInLinuxImage (stdenv.mkDerivation (

  {
    doCheck = true;

    prefix = "/usr";

    phases = "installExtraDebsPhase sysInfoPhase unpackPhase patchPhase configurePhase buildPhase checkPhase installPhase distPhase";
  }

  // removeAttrs args ["vmTools"] //

  {
    name = name + "-" + diskImage.name + (if src ? version then "-" + src.version else "");

    src = if src ? outPath then src.outPath else src.path;
  
    # !!! cut&paste from rpm-build.nix
    postHook = ''
      ensureDir $out/nix-support
      cat "$diskImage"/nix-support/full-name > $out/nix-support/full-name

      # If `src' is the result of a call to `makeSourceTarball', then it
      # has a subdirectory containing the actual tarball(s).  If there are
      # multiple tarballs, just pick the first one.
      echo $src
      if test -d $src/tarballs; then
          src=$(ls $src/tarballs/*.tar.bz2 $src/tarballs/*.tar.gz | sort | head -1)
      fi
    ''; # */

    installExtraDebsPhase = ''
      for i in $extraDebs; do
        dpkg --install $i    
      done
    '';

    sysInfoPhase = ''
      echo "System/kernel: $(uname -a)"
      if test -e /etc/debian_version; then echo "Debian release: $(cat /etc/debian_version)"; fi
      header "installed Debian packages"
      dpkg-query --list
      stopNest
    '';

    installCommand = ''
      export LOGNAME=root

      ${checkinstall}/sbin/checkinstall -y -D make install

      ensureDir $out/debs
      find . -name "*.deb" -exec cp {} $out/debs \;

      shopt -s nullglob
      for i in $out/debs/*.deb; do
        header "Generated DEB package: $i"
        dpkg-deb --info $i
        echo "file deb $i" >> $out/nix-support/hydra-build-products
        stopNest
      done
    ''; # */

    meta = (if args ? meta then args.meta else {}) // {
      description = "Build of a Deb package on ${diskImage.fullName} (${diskImage.name})";
    };
  }

))
