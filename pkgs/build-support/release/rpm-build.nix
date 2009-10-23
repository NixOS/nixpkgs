# This function builds an RPM from a source tarball that contains a
# RPM spec file (i.e., one that can be built using `rpmbuild -ta').

{ name ? "rpm-build"
, diskImage
, src, vmTools
, ... } @ args:

vmTools.buildRPM (

  removeAttrs args ["vmTools"] //

  {
    name = name + "-" + diskImage.name + (if src ? version then "-" + src.version else "");

    preBuild = ''
      ensureDir $out/nix-support
      cat "$diskImage"/nix-support/full-name > $out/nix-support/full-name

      # If `src' is the result of a call to `makeSourceTarball', then it
      # has a subdirectory containing the actual tarball(s).  If there are
      # multiple tarballs, just pick the first one.
      if test -d $src/tarballs; then
          src=$(ls $src/tarballs/*.tar.bz2 $src/tarballs/*.tar.gz | sort | head -1)
      fi
    ''; # */

    postInstall = ''
      for i in $out/rpms/*/*.rpm; do
        if echo $i | grep -vq "\.src\.rpm$"; then
          echo "file rpm $i" >> $out/nix-support/hydra-build-products
        fi
      done
      for i in $out/rpms/*/*.src.rpm; do
        echo "file srpm $i" >> $out/nix-support/hydra-build-products
      done
      for rpmdir in $extraRPMs ; do
        echo "file rpm-extra $(ls $rpmdir/rpms/*/*.rpm | grep -v 'src\.rpm' | sort | head -1)" >> $out/nix-support/hydra-build-products
      done
    ''; # */

    meta = (if args ? meta then args.meta else {}) // {
      description = "Build of an RPM package on ${diskImage.fullName} (${diskImage.name})";
    };
  }

)
