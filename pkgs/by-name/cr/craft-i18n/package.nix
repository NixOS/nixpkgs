{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "craft-i18n";
  version = "0-unstable-2026-11-11";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "craft-i18n";
    rev = "74e77706491d260c868bec6df686f92b90baae38";
    hash = "sha256-DdiTpSIguH9XU5TdonpqB/CLvtpX6Bt10Sub4DL2AMs=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -R locales language-data $out/

    runHook postInstall
  '';

  meta = {
    description = "Shared translations and proofing language data for the ArtCraft suite (CRAFT_I18N_DIR)";
    homepage = "https://github.com/storytold/craft-i18n";
    license = lib.licenses.OR [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = with lib.maintainers; [ cleboost ];
    platforms = lib.platforms.all;
  };
}
