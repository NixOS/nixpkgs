{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "arashi";
  version = "25.09";

  src = fetchFromGitHub {
    owner = "0hStormy";
    repo = "Arashi";
    tag = finalAttrs.version;
    hash = "sha256-qSr6wj+O6ieWxgKQxmUz7I3De9MOF5cq0I5DpD8+tug=";
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
