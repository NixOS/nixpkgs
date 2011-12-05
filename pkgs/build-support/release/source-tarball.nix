# This function converts an un-Autoconfed source tarball (typically a
# checkout from a Subversion or CVS repository) into a source tarball
# by running `autoreconf', `configure' and `make dist'.

{ officialRelease ? false
, buildInputs ? []
, name ? "source-tarball"
, version ? "0"
, versionSuffix ? 
    if officialRelease
    then ""
    else if src ? rev then "pre${toString src.rev}" else ""
, src, stdenv, autoconf, automake, libtool
, ... } @ args:

let

  # By default, provide all the GNU Build System as input.
  bootstrapBuildInputs =
    if (args ? bootstrapBuildInputs)
    then args.bootstrapBuildInputs
    else [ autoconf automake libtool ];

in

stdenv.mkDerivation (

  # First, attributes that can be overriden by the caller (via args):
  {
    # By default, only configure and build a source distribution.
    # Some packages can only build a distribution after a general
    # `make' (or even `make install').
    dontBuild = true;
    dontInstall = true;
    doDist = true;

    # If we do install, install to a dummy location.
    useTempPrefix = true;

    showBuildStats = true;

    preConfigurePhases = "autoconfPhase";
    postPhases = "finalPhase";

    # Autoconfiscate the sources.
    autoconfPhase = ''
      export VERSION=${version}
      export VERSION_SUFFIX=${versionSuffix}

      # `svn-revision' is set for backwards compatibility with the old
      # Nix buildfarm.  (Stratego/XT's autoxt uses it.  We should
      # update it eventually.)
      echo ${versionSuffix} | sed -e s/pre// > svn-revision

      eval "$preAutoconf"

      if test -x ./bootstrap; then ./bootstrap
      elif test -x ./bootstrap.sh; then ./bootstrap.sh
      elif test -x ./autogen.sh; then ./autogen.sh
      elif test -x ./autogen ; then ./autogen
      elif test -x ./reconf; then ./reconf
      elif test -f ./configure.in || test -f ./configure.ac; then
          autoreconf --install --force --verbose
      else
          echo "No bootstrap, bootstrap.sh, configure.in or configure.ac. Assuming this is not an GNU Autotools package."
      fi

      eval "$postAutoconf"
    '';

    failureHook = ''
      if test -n "$succeedOnFailure"; then
          if test -n "$keepBuildDirectory"; then
              KEEPBUILDDIR="$out/`basename $TMPDIR`"
              header "Copying build directory to $KEEPBUILDDIR"
              ensureDir $KEEPBUILDDIR
              cp -R $TMPDIR/* $KEEPBUILDDIR
              stopNest
          fi
      fi
    '';
  }

  # Then, the caller-supplied attributes.
  // args // 

  # And finally, our own stuff.
  {
    name = name + "-" + version + versionSuffix;

    buildInputs = buildInputs ++ bootstrapBuildInputs;
    
    postHook = ''
      ensureDir $out/nix-support
    '';  

    postUnpack = ''
      # Set all source files to the current date.  This is because Nix
      # resets the timestamp on all files to 0 (1/1/1970), which some
      # people don't like (in particular GNU tar prints harmless but
      # frightening warnings about it).
      touch now
      touch -d "1970-01-01 00:00:00 UTC" then
      find $sourceRoot ! -newer then -print0 | xargs -0r touch --reference now
      eval "$nextPostUnpack"
    '';

    nextPostUnpack = if args ? postUnpack then args.postUnpack else "";

    # Cause distPhase to copy tar.bz2 in addition to tar.gz.
    tarballs = "*.tar.gz *.tar.bz2 *.tar.xz";

    finalPhase = ''
      for i in "$out/tarballs/"*; do
          echo "file source-dist $i" >> $out/nix-support/hydra-build-products
      done

      # Try to figure out the release name.
      releaseName=$( (cd $out/tarballs && ls) | head -n 1 | sed -e 's^\.[a-z].*^^')
      test -n "$releaseName" && (echo "$releaseName" >> $out/nix-support/hydra-release-name)
    '';

    passthru = {
      inherit src;
      version = version + versionSuffix;
    };

    meta = (if args ? meta then args.meta else {}) // {
      description = "Build of a source distribution from a checkout";

      # Tarball builds are generally important, so give them a high
      # default priority.
      schedulingPriority = "200";
    };
  }

)
