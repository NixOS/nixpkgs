{
  stdenv,
  libpkgconf,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "pkgconf-lite";
  inherit (libpkgconf) version src;

  __structuredAttrs = true;
  strictDeps = true;
  enableParallelBuilding = true;

  makefile = "Makefile.lite";

  makeFlags = [
    "SYSTEM_LIBDIR=/no-system-libdir"
    "SYSTEM_INCLUDEDIR=/no-system-includedir"
    "PKG_DEFAULT_PATH=/no-pkg-default-path"
  ];

  installPhase = ''
    runHook preBuild
    install -Dm644 pkg.m4 $out/share/aclocal/pkg.m4
    install -Dm755 pkgconf-lite $out/bin/pkgconf
    ln -s pkgconf $out/bin/pkg-config
    runHook postBuild
  '';

  meta = libpkgconf.meta // {
    description = libpkgconf.meta.description + " (for early bootstrap)";
    outputsToInstall = [ "out" ];
  };
})
