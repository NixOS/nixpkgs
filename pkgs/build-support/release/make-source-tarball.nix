# This function converts an un-Autoconfed source tarball (typically a
# checkout from a Subversion or CVS repository) into a source tarball
# by running `autoreconf', `configure' and `make dist'.

args: with args;

stdenv.mkDerivation (

  # First, attributes that can be overriden by the caller (via args):
  {
    name = "source-tarball";

    # By default, only configure and build a source distribution.
    # Some packages can only build a distribution after a general
    # `make' (or even `make install').
    dontBuild = true;
    dontInstall = true;
    doDist = true;

    # If we do install, install to a dummy location.
    useTempPrefix = true;

    showBuildStats = true;

    phases = "unpackPhase patchPhase autoconfPhase configurePhase buildPhase installPhase checkPhase distPhase";
  }

  # Then, the caller-supplied attributes.
  // args // 

  # And finally, our own stuff.
  {
    src = src.path;

    buildInputs =
      stdenv.lib.optionals (args ? buildInputs) args.buildInputs ++
      [autoconf automake];
    
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

    preConfigure = ''
      # Some packages1 use the file `svn-revision' to construct the
      # release name.
      rev="${if src ? rev then toString src.rev else ""}"
      if test -n "$rev"; then echo "$rev" > svn-revision; fi
      eval "$nextPreConfigure"
    '';

    nextPreConfigure = if args ? preConfigure then args.preConfigure else "";

    # Autoconfiscate the sources.
    autoconfPhase = ''
      eval "$preAutoconf"
    
      if test -f ./bootstrap; then ./bootstrap
      elif test -f ./bootstrap.sh; then ./bootstrap.sh
      elif test -f ./reconf; then ./reconf
      elif test -f ./configure.in || test -f ./configure.ac; then
          autoreconf --install --force --verbose
      else
          echo "No bootstrap, bootstrap.sh, configure.in or configure.ac. Assuming this is not an GNU Autotools package."
      fi
    
      eval "$postAutoconf"
    '';

    # Cause distPhase to copy tar.bz2 in addition to tar.gz.
    tarballs = "*.tar.gz *.tar.bz2";

    postDist = ''
      shopt -s nullglob
      for i in $out/tarballs/*; do
        echo "file source-dist $i" >> $out/nix-support/hydra-build-products
      done
    ''; # */

    passthru = {inherit src;};

    meta = {
      description = "Build of a source distribution from a checkout";
    };
  
  }

)
