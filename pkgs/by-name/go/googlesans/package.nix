{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
  nix-update-script,
  python3Packages,
  static ? false,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "googlesans" + lib.optionalString static "-static";
  version = "14.000";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "googlesans";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R/ebkcQu8tH/VZvodCEwLW5A2y83TSQb3yGa81fXKlM=";
  };

  nativeBuildInputs = [
    installFonts
    python3Packages.fontmake
    python3Packages.fonttools
    python3Packages.python
    python3Packages.ufo2ft
    python3Packages.ufolib2
    python3Packages.uharfbuzz
  ]
  ++ python3Packages.fontmake.optional-dependencies.pathops;

  postPatch = ''
    # Remove test fonts so that they don't get copied over by installFonts
    rm docs/old/GoogleSans-Text/Cyrillic/Text/Testing\ TTFs/*

    # Do not append a commit hash to the version
    substituteInPlace source/Makefile \
      --replace-fail 'font-v write --sha1 $@' ""
  '';

  buildFlags = [
    (if static then "gs-static" else "gs-vf")
  ];

  preInstall = ''
    # Remove intermediate fonts so that they don't get copied over by installFonts
    rm build/GoogleSans/.intermediate/*
  '';

  # Do nothing, installFonts handles the installation
  installPhase = ''
    runHook preInstall
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description =
      "Current generation of Google's brand typeface, with wide language support"
      + lib.optionalString static " (static fonts)";
    homepage = "https://fonts.google.com/specimen/Google+Sans";
    changelog = "https://github.com/googlefonts/googlesans/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ wulpine ];
    platforms = lib.platforms.all;
  };
})
