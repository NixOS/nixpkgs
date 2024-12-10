/*
  This function builds a binary tarball.  The resulting binaries are
  usually only useful if they are don't have any runtime dependencies
  on any paths in the Nix store, since those aren't distributed in
  the tarball.  For instance, the binaries should be statically
  linked: they can't depend on dynamic libraries in the store
  (including Glibc).

  The binaries are built and installed with a prefix of /usr/local by
  default.  They are installed by setting DESTDIR to a temporary
  directory, so the Makefile of the package should support DESTDIR.
*/

{
  src,
  lib,
  stdenv,
  name ? "binary-tarball",
  ...
}@args:

stdenv.mkDerivation (

  {
    # Also run a `make check'.
    doCheck = true;

    showBuildStats = true;

    prefix = "/usr/local";

    postPhases = "finalPhase";
  }

  // args
  //

    {
      name = name + (lib.optionalString (src ? version) "-${src.version}");

      postHook = ''
        mkdir -p $out/nix-support
        echo "$system" > $out/nix-support/system
        . ${./functions.sh}

        origSrc=$src
        src=$(findTarball $src)

        if test -e $origSrc/nix-support/hydra-release-name; then
            releaseName=$(cat $origSrc/nix-support/hydra-release-name)
        fi

        installFlagsArray=(DESTDIR=$TMPDIR/inst)

        # Prefix hackery because of a bug in stdenv (it tries to `mkdir
        # $prefix', which doesn't work due to the DESTDIR).
        configureFlags="--prefix=$prefix $configureFlags"
        dontAddPrefix=1
        prefix=$TMPDIR/inst$prefix
      '';

      doDist = true;

      distPhase = ''
        mkdir -p $out/tarballs
        tar cvfj $out/tarballs/''${releaseName:-binary-dist}.tar.bz2 -C $TMPDIR/inst .
      '';

      finalPhase = ''
        for i in $out/tarballs/*; do
            echo "file binary-dist $i" >> $out/nix-support/hydra-build-products
        done

        # Propagate the release name of the source tarball.  This is
        # to get nice package names in channels.
        test -n "$releaseName" && (echo "$releaseName" >> $out/nix-support/hydra-release-name)
      '';

      meta = (lib.optionalAttrs (args ? meta) args.meta) // {
        description = "Build of a generic binary distribution";
      };

    }
)
