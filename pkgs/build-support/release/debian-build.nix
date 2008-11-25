# This function compiles a source tarball in a virtual machine image
# that contains a Debian-like (i.e. dpkg-based) OS.  Currently this is
# just for portability testing: it doesn't produce any Debian
# packages.

vmTools: args: with args;

vmTools.runInLinuxImage (stdenv.mkDerivation (

  {
    name = "debian-build";

    doCheck = true;

    # Don't install the result in the Nix store.
    useTempPrefix = true;

    phases = "sysInfoPhase unpackPhase patchPhase configurePhase buildPhase checkPhase installPhase distPhase";
  }

  // args //

  {
    src = src.path;
  
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

    sysInfoPhase = ''
      echo "System/kernel: $(uname -a)"
      if test -e /etc/debian_version; then echo "Debian release: $(cat /etc/debian_version)"; fi
      header "installed Debian packages"
      dpkg-query --list
      stopNest
    '';

    meta = {
      description = "Test build on ${args.diskImage.fullName} (${args.diskImage.name})";
    };
  }

))
