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

  # for passthru.tests
  pango,
  libass,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fribidi";
  version = "1.0.17";

  __structuredAttrs = true;
  strictDeps = true;

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
    sha256 = "sha256-aUnc3ifUHOutH9dB/K/DbVWhAg0thy1KbrORTKq7raI=";
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

  # necessary to compile helper which runs during build to generate tables
  # see gen.tab/meson.build for details
  depsBuildBuild = [ buildPackages.stdenv.cc ];

  mesonFlags = lib.mapAttrsToList lib.mesonBool {
    tests = finalAttrs.finalPackage.doCheck;
    docs = true;
    bin = true;
    deprecated = true;
  };

  doCheck = true;
  nativeCheckInputs = [ python3 ];

  passthru.tests = {
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
    inherit pango libass;
  };

  meta = {
    homepage = "https://github.com/fribidi/fribidi";
    changelog = "https://github.com/fribidi/fribidi/releases/tag/v${finalAttrs.version}";
    description = "GNU implementation of the Unicode Bidirectional Algorithm (bidi)";
    mainProgram = "fribidi";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.unix;
    pkgConfigModules = [ "fribidi" ];
    maintainers = with lib.maintainers; [ tmarkus ];
  };
})
