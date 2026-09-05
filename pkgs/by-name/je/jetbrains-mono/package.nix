{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3Packages,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "jetbrains-mono";
  version = "2.304";

  src = fetchFromGitHub {
    owner = "jetbrains";
    repo = "jetbrainsmono";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SW9d5yVud2BWUJpDOlqYn1E1cqicIHdSZjbXjqOAQGw=";
  };

  env."PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION" = "python";

  nativeBuildInputs = [
    python3Packages.gftools
    installFonts
  ];

  buildPhase = ''
    runHook preBuild
    gftools builder sources/config.yaml
    runHook postBuild
  '';

  # gftools pulls in ninja which we don't need here.
  dontUseNinjaInstall = true;

  outputs = [
    "out"
    "webfont"
  ];

  meta = {
    description = "Typeface made for developers";
    homepage = "https://jetbrains.com/mono/";
    changelog = "https://github.com/JetBrains/JetBrainsMono/blob/v${finalAttrs.src.tag}/Changelog.md";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ vinnymeller ];
    platforms = lib.platforms.all;
  };
})
