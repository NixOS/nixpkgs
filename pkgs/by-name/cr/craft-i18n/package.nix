{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "craft-i18n";
  version = "0-unstable-2026-11-04";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "craft-i18n";
    rev = "9d6d54d6d9ff603cc41e12e5f6ba51af3554ab66";
    hash = "sha256-Y9/L81MircA76USE4GSbRqei8XHQhxlvov1jhkhOaB8=";
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
