{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "arashi";
  version = "25.08.3";

  src = fetchFromGitHub {
    owner = "0hStormy";
    repo = "Arashi";
    tag = finalAttrs.version;
    hash = "sha256-wmYsAfgdwn6ZLF70avNmjoU5VZNBZdV7dPSe8ycNdHE=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/Arashi
    cp -r . $out/share/icons/Arashi/

    runHook postInstall
  '';

  meta = {
    description = "Arashi icon theme";
    homepage = "https://github.com/0hStormy/Arashi";
    license = lib.licenses.cc-by-sa-40;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ritascarlet ];
  };
})
