{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fontc,
  installFonts,
  nix-update-script,
  python3Packages,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "googlesans-flex";
  version = "5.000";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "googlesans-flex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dF8uLSOwPODMAdEEUFtJT4wJAL+PHpUNtcZN8CPb3Sg=";
  };

  nativeBuildInputs = [
    installFonts
    python3Packages.fonttools
    python3Packages.gftools
    python3Packages.python
  ];

  # gftools propagates ninja which isn't used here
  dontUseNinjaBuild = true;
  dontUseNinjaCheck = true;
  dontUseNinjaInstall = true;

  postPatch = ''
    # Remove demo fonts so that they don't get copied over by installFonts
    rm documentation/demo-fonts/*

    # Use dependencies from nixpkgs
    substituteInPlace Makefile \
      --replace-fail '$(UV_RUN) gftools' "gftools" \
      --replace-fail \
        '$(shell uv run --with-requirements requirements.txt which fontc)' \
        "${lib.getExe fontc}" \
      --replace-fail '$(UV_RUN)' "python"
  '';

  buildFlags = [
    # Do not append a commit hash to the version
    "SKIP_FONTV=1"
    "build"
  ];

  # Do nothing, installFonts handles the installation
  installPhase = ''
    runHook preInstall
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      # There are tags that are not actual releases
      "--use-github-releases"
    ];
  };

  meta = {
    description = "Next generation of Google's brand typeface";
    homepage = "https://fonts.google.com/specimen/Google+Sans+Flex";
    changelog = "https://github.com/googlefonts/googlesans-flex/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ wulpine ];
    platforms = lib.platforms.all;
  };
})
