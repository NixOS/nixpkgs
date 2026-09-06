{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  pname = "koruri";
  version = "20210720";

  src = fetchFromGitHub {
    owner = "Koruri";
    repo = "Koruri";
    rev = version;
    hash = "sha256-zL9UtT15mWvsXgGJqbTs6cOsQaoh/0AIAyQ5z7JpTXk=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm644 *.ttf -t $out/share/fonts/koruri
    runHook postInstall
  '';

  meta = {
    description = "Japanese TrueType font obtained by mixing M+ FONTS and Open Sans";
    homepage = "https://github.com/Koruri/Koruri";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ haruki7049 ];
    platforms = lib.platforms.all;
  };
}
