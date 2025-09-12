{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
  pcre2,
  pkg-config,
  libsepol,
  enablePython ? false,
  swig ? null,
  python3 ? null,
  python3Packages ? null,
  fts,
}:

assert enablePython -> swig != null && python3 != null;

stdenv.mkDerivation (finalAttrs: {
  pname = "libselinux";
  version = "3.8.1";
  inherit (libsepol) se_url;

  outputs = [
    "bin"
    "out"
    "dev"
    "man"
  ]
  ++ lib.optional enablePython "py";

  src = fetchurl {
    url = "${finalAttrs.se_url}/${finalAttrs.version}/libselinux-${finalAttrs.version}.tar.gz";
    hash = "sha256-7C0nifkxFS0hwdsetLwgLOTszt402b6eNg47RSQ87iw=";
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
      url = "https://lore.kernel.org/selinux/20250211211651.1297357-3-hi@alyssa.is/raw";
      hash = "sha256-a0wTSItj5vs8GhIkfD1OPSjGmAJlK1orptSE7T3Hx20=";
      postFetch = ''
        mv "$out" $TMPDIR/patch
        ${buildPackages.patchutils_0_3_3}/bin/filterdiff \
            -i 'a/libselinux/*' --strip 1 <$TMPDIR/patch >"$out"
      '';
    })

    (fetchurl {
      url = "https://git.yoctoproject.org/meta-selinux/plain/recipes-security/selinux/libselinux/0003-libselinux-restore-drop-the-obsolete-LSF-transitiona.patch?id=62b9c816a5000dc01b28e78213bde26b58cbca9d";
      hash = "sha256-RiEUibLVzfiRU6N/J187Cs1iPAih87gCZrlyRVI2abU=";
    })

    # commit 5c3fcbd931b7f9752b5ce29cec3b6813991d61c0 plus an additional
    # fix for a musl build regression caused by that commit:
    # https://lore.kernel.org/selinux/20250426151356.7116-2-hi@alyssa.is/
    # Fix build on 32-bit LFS platforms
    ./fix-build-32bit-lfs.patch
  ];

  nativeBuildInputs = [
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
  ]
  ++ lib.optionals enablePython [ python3 ];

  # drop fortify here since package uses it by default, leading to compile error:
  # command-line>:0:0: error: "_FORTIFY_SOURCE" redefined [-Werror]
  hardeningDisable = [ "fortify" ];

  env = {
    NIX_CFLAGS_COMPILE = "-Wno-error -D_FILE_OFFSET_BITS=64";
  }
  //
    lib.optionalAttrs (stdenv.cc.bintools.isLLVM && lib.versionAtLeast stdenv.cc.bintools.version "17")
      {
        NIX_LDFLAGS = "--undefined-version";
      };

  makeFlags = [
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

  preFixup = lib.optionalString enablePython ''
    mv $out/${python3.sitePackages}/selinux/* $py/${python3.sitePackages}/selinux/
    rm -rf $out/lib/python*
  '';

  meta = removeAttrs libsepol.meta [ "outputsToInstall" ] // {
    description = "SELinux core library";
  };
})
