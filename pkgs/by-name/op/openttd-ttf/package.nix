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
  version = "0.8";

  src = fetchFromGitHub {
    owner = "OpenTTD";
    repo = "openttd-ttf";
    tag = finalAttrs.version;
    hash = "sha256-ZV74ZQ4Z4jw2tjG3kXj4Vo1J+W3BF0SJIFIae9DWLAc=";
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

  buildPhase = ''
    runHook preBuild
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

  meta = {
    homepage = "https://github.com/OpenTTD/OpenTTD-TTF";
    changelog = "https://github.com/OpenTTD/OpenTTD-TTF/releases/tag/${finalAttrs.version}";
    description = "TrueType typefaces for text in a pixel art style, designed for use in OpenTTD";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.sfrijters ];
  };
})
