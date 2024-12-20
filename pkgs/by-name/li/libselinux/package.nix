{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
  pcre2,
  pkg-config,
  libsepol,
  enablePython ? !stdenv.hostPlatform.isStatic,
  swig ? null,
  python3 ? null,
  python3Packages,
  fts,
}:

assert enablePython -> swig != null && python3 != null;

stdenv.mkDerivation (
  rec {
    pname = "libselinux";
    version = "3.7";
    inherit (libsepol) se_url;

    outputs = [
      "bin"
      "out"
      "dev"
      "man"
    ] ++ lib.optional enablePython "py";

    src = fetchurl {
      url = "${se_url}/${version}/libselinux-${version}.tar.gz";
      hash = "sha256-6gP0LROk+VdXmX26jPCyYyH6xdLxZEGLTMhWqS0rF70=";
    };

    patches = [
      # Make it possible to disable shared builds (for pkgsStatic).
      #
      # We can't use fetchpatch because it processes includes/excludes
      # /after/ stripping the prefix, which wouldn't work here because
      # there would be no way to distinguish between
      # e.g. libselinux/src/Makefile and libsepol/src/Makefile.
      #
      # This is a static email, so we shouldn't have to worry about
      # normalizing the patch.
      (fetchurl {
        url = "https://lore.kernel.org/selinux/20211113141616.361640-1-hi@alyssa.is/raw";
        sha256 = "16a2s2ji9049892i15yyqgp4r20hi1hij4c1s4s8law9jsx65b3n";
        postFetch = ''
          mv "$out" $TMPDIR/patch
          ${buildPackages.patchutils_0_3_3}/bin/filterdiff \
              -i 'a/libselinux/*' --strip 1 <$TMPDIR/patch >"$out"
        '';
      })

      (fetchurl {
        url = "https://git.yoctoproject.org/meta-selinux/plain/recipes-security/selinux/libselinux/0003-libselinux-restore-drop-the-obsolete-LSF-transitiona.patch?id=62b9c816a5000dc01b28e78213bde26b58cbca9d";
        sha256 = "sha256-RiEUibLVzfiRU6N/J187Cs1iPAih87gCZrlyRVI2abU=";
      })
    ];

    nativeBuildInputs =
      [
        pkg-config
        python3
      ]
      ++ lib.optionals enablePython [
        python3Packages.pip
        python3Packages.setuptools
        python3Packages.wheel
        swig
      ];
    buildInputs = [
      libsepol
      pcre2
      fts
    ] ++ lib.optionals enablePython [ python3 ];

    # drop fortify here since package uses it by default, leading to compile error:
    # command-line>:0:0: error: "_FORTIFY_SOURCE" redefined [-Werror]
    hardeningDisable = [ "fortify" ];

    env.NIX_CFLAGS_COMPILE = "-Wno-error -D_FILE_OFFSET_BITS=64";

    makeFlags =
      [
        "PREFIX=$(out)"
        "INCDIR=$(dev)/include/selinux"
        "INCLUDEDIR=$(dev)/include"
        "MAN3DIR=$(man)/share/man/man3"
        "MAN5DIR=$(man)/share/man/man5"
        "MAN8DIR=$(man)/share/man/man8"
        "SBINDIR=$(bin)/sbin"
        "SHLIBDIR=$(out)/lib"

        "LIBSEPOLA=${lib.getLib libsepol}/lib/libsepol.a"
        "ARCH=${stdenv.hostPlatform.linuxArch}"
      ]
      ++ lib.optionals (fts != null) [
        "FTS_LDLIBS=-lfts"
      ]
      ++ lib.optionals stdenv.hostPlatform.isStatic [
        "DISABLE_SHARED=y"
      ]
      ++ lib.optionals enablePython [
        "PYTHON=${python3.pythonOnBuildForHost.interpreter}"
        "PYTHONLIBDIR=$(py)/${python3.sitePackages}"
        "PYTHON_SETUP_ARGS=--no-build-isolation"
      ];

    preInstall = lib.optionalString enablePython ''
      mkdir -p $py/${python3.sitePackages}/selinux
    '';

    installTargets = [ "install" ] ++ lib.optional enablePython "install-pywrap";

    meta = removeAttrs libsepol.meta [ "outputsToInstall" ] // {
      description = "SELinux core library";
    };
  }
  //
    lib.optionalAttrs (stdenv.cc.bintools.isLLVM && lib.versionAtLeast stdenv.cc.bintools.version "17")
      {
        NIX_LDFLAGS = "--undefined-version";
      }
)
