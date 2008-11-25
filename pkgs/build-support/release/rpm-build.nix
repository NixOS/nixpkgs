# This function builds an RPM from a source tarball that contains a
# RPM spec file (i.e., one that can be built using `rpmbuild -ta').

vmTools: args: with args;

vmTools.buildRPM (

  {
    name = "rpm-build";
  }

  // args //

  {
    src = src.path;

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
      shopt -s nullglob
      for i in $out/rpms/*/*.rpm; do
        echo "file rpm $i" >> $out/nix-support/hydra-build-products
      done
    ''; # */

    meta = {
      description = "Build of an RPM package on ${args.diskImage.fullName} (${args.diskImage.name})";
    };
  }

)
