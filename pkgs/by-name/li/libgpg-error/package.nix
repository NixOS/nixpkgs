{
  stdenv,
  lib,
  autoreconfHook,
  buildPackages,
  fetchurl,
  gettext,
  genPosixLockObjOnly ? false,
}:
let
  genPosixLockObjOnlyAttrs = lib.optionalAttrs genPosixLockObjOnly {
    buildPhase = ''
      cd src
      make gen-posix-lock-obj
    '';

    installPhase = ''
      mkdir -p $out/bin
      install -m755 gen-posix-lock-obj $out/bin
    '';

    outputs = [ "out" ];
    outputBin = "out";
  };
in
stdenv.mkDerivation (
  rec {
    pname = "libgpg-error";
    version = "1.61";

    src = fetchurl {
      url = "mirror://gnupg/libgpg-error/libgpg-error-${version}.tar.bz2";
      hash = "sha256-eoVBPyvDVPT4qoMrcYrxIuSJZeng65AS7mWcE8Y4XJM=";
    };

    patches = [
      # Fixes t-printf test on platforms where LDBL_MAX == DBL_MAX (armhf, ppc64)
      # Upstream's git forge doesn't seem to have a nice way to download it :/
      ./libgpg-error-tests-skip-a-test-when-not-HAVE_LONG_DOUBLE_WIDER.patch
    ];

    postPatch = ''
      sed '/BUILD_TIMESTAMP=/s/=.*/=1970-01-01T00:01+0000/' -i ./configure
    ''
    # libgpg-error insists on having these generated files. They should be fairly ABI stable,
    # so add one for FreeBSD.
    + lib.optionalString (stdenv.hostPlatform.system == "x86_64-freebsd") ''
      cp ${./lock-obj-pub.x86_64-unknown-freebsd.h} src/syscfg/lock-obj-pub.freebsd.h
    ''
    # Fails on powerpc64-linux
    # https://lists.gnupg.org/pipermail/gnupg-users/2026-July/068440.html
    + lib.optionalString (stdenv.hostPlatform.isPower64 && stdenv.hostPlatform.isBigEndian) ''
      substituteInPlace tests/t-printf.c \
        --replace-fail \
          '# ifdef HAVE_LONG_DOUBLE_WIDER' \
          '# if 0' \
        --replace-fail \
          'show ("LDBL_MAX == DBL_MAX - skipping LDBL_MAX test\n")' \
          'show ("LDBL_MAX is weird on this platform - skipping LDBL_MAX test\n")'
    '';

    hardeningDisable = [ "strictflexarrays3" ];

    configureFlags = [
      # See https://dev.gnupg.org/T6257#164567
      "--enable-install-gpg-error-config"
    ];

    outputs = [
      "out"
      "dev"
      "info"
    ];
    outputBin = "dev"; # deps want just the lib, most likely

    # If architecture-dependent MO files aren't available, they're generated
    # during build, so we need gettext for cross-builds.
    depsBuildBuild = [ buildPackages.stdenv.cc ];
    nativeBuildInputs = [
      autoreconfHook # HAVE_LONG_DOUBLE_WIDER patch changes configure.ac
      gettext
    ];

    strictDeps = true;

    postConfigure =
      # For some reason, /bin/sh on OpenIndiana leads to this at the end of the
      # `config.status' run:
      #   ./config.status[1401]: shift: (null): bad number
      # (See <https://hydra.nixos.org/build/2931046/nixlog/1/raw>.)
      # Thus, re-run it with Bash.
      lib.optionalString stdenv.hostPlatform.isSunOS ''
        ${stdenv.shell} config.status
      ''
      # ./configure erroneous decides to use weak symbols on pkgsStatic,
      # which, together with other defines results in locking functions in
      # src/posix-lock.c to be no-op, causing tests/t-lock.c to fail.
      + lib.optionalString stdenv.hostPlatform.isStatic ''
        sed '/USE_POSIX_THREADS_WEAK/ d' config.h
        echo '#undef USE_POSIX_THREADS_WEAK' >> config.h
      '';

    doCheck = true; # not cross

    meta = {
      homepage = "https://www.gnupg.org/software/libgpg-error/index.html";
      changelog = "https://git.gnupg.org/cgi-bin/gitweb.cgi?p=libgpg-error.git;a=blob;f=NEWS;hb=refs/tags/libgpg-error-${version}";
      description = "Small library that defines common error values for all GnuPG components";
      mainProgram = "gen-posix-lock-obj";

      longDescription = ''
        Libgpg-error is a small library that defines common error values
        for all GnuPG components.  Among these are GPG, GPGSM, GPGME,
        GPG-Agent, libgcrypt, Libksba, DirMngr, Pinentry, SmartCard
        Daemon and possibly more in the future.
      '';

      license = lib.licenses.lgpl2Plus;
      platforms = lib.platforms.all;
      maintainers = [ ];
    };
  }
  // genPosixLockObjOnlyAttrs
)
