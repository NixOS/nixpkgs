{
  lib,
  stdenv,
  buildPackages,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  fixDarwinDylibNames,
  python3,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fribidi";
  version = "1.0.16";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  # NOTE: Only URL tarball has "Have pre-generated man pages: true", which works-around upstream usage of some rare ancient `c2man` fossil application.
  src = fetchurl {
    url =
      with finalAttrs;
      "https://github.com/fribidi/fribidi/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-GxzeWyNdQEeekb4vDoijCeMhTIq0cOyKJ0TYKlqeoFw=";
  };

  postPatch = ''
    patchShebangs test
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  # Cross builds cannot execute target binaries.
  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  nativeCheckInputs = [ python3 ];

  passthru.tests = {
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    homepage = "https://github.com/fribidi/fribidi";
    description = "GNU implementation of the Unicode Bidirectional Algorithm (bidi)";
    mainProgram = "fribidi";
    license = lib.licenses.lgpl21;
    # MSYS2 ships fribidi for MinGW; allow Windows so pkgsCross.mingwW64 can evaluate it.
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    pkgConfigModules = [ "fribidi" ];
  };
})
