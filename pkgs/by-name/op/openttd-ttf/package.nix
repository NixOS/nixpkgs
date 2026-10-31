{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  openttd,
  installFonts,
  doCheck ? false,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "openttd-ttf";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "OpenTTD";
    repo = "openttd-ttf";
    tag = finalAttrs.version;
    hash = "sha256-tn9DktwXCdG3DMeV6jpk31IO0ZncT6givjk3hJp5K18=";
  };

  nativeBuildInputs = [
    installFonts
    (python3.withPackages (
      pp:
      with pp;
      [
        fontforge
        pillow
        setuptools
      ]
      ++ lib.optionals (finalAttrs.finalPackage.doCheck) [
        fonttools
      ]
    ))
  ];

  strictDeps = true;

  buildPhase = ''
    runHook preBuild
    # https://github.com/OpenTTD/OpenTTD-TTF/commit/2ae6c643f507bc1ab6dcd12abdc2fb48190e249e
    # Remove this after next release
    rm -r ./ttf
    # The font files already exist, force a rebuild
    make -B
    runHook postBuild
  '';

  inherit doCheck;
  checkPhase = lib.optionalString (finalAttrs.finalPackage.doCheck) ''
    runHook preCheck
    python3 checkOpenTTDStrings.py ${openttd.src}/src/lang
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    runHook postInstall
  '';

  passthru.tests.withCheck = finalAttrs.finalPackage.overrideAttrs { doCheck = true; };

  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/OpenTTD/OpenTTD-TTF";
    changelog = "https://github.com/OpenTTD/OpenTTD-TTF/releases/tag/${finalAttrs.version}";
    description = "TrueType typefaces for text in a pixel art style, designed for use in OpenTTD";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.sfrijters ];
  };
})
