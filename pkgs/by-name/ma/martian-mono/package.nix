{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
  python3Packages,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "martian-mono";
  version = "1.1.0";

  outputs = [
    "out"
    "webfont"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "evilmartians";
    repo = "mono";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qm1Ljz344BTesQXIjKwuE4XwXwskZQlNkCgaVyst54o=";
  };

  env.PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";

  nativeBuildInputs = [
    python3Packages.gftools
    python3Packages.fontmake
    installFonts
  ];

  buildPhase = ''
    runHook preBuild
    # clean out the prebuilt files
    rm -r fonts
    gftools builder sources/config.yaml
    runHook postBuild
  '';

  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;

  meta = {
    description = "Free and open-source monospaced font from Evil Martians";
    homepage = "https://github.com/evilmartians/mono";
    changelog = "https://github.com/evilmartians/mono/raw/${finalAttrs.src.tag}/Changelog.md";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ pancaek ];
    platforms = lib.platforms.all;
  };
})
