{ lib
, fetchFromGitHub
, stdenvNoCC
}:

stdenvNoCC.mkDerivation rec {
  pname = "koruri";
  version = "20210720";

  src = fetchFromGitHub {
    owner = "Koruri";
    repo = "Koruri";
    rev = "6e173461858616f7b701b8e297b3e408ae224c7f";
    hash = "sha256-zL9UtT15mWvsXgGJqbTs6cOsQaoh/0AIAyQ5z7JpTXk=";
  };
  installPhase = ''
    runHook preInstall
    install -Dm644 *.ttf -t $out/share/fonts/${pname}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Japanese TrueType font obtained by mixing M+ FONTS and Open Sans";
    homepage = "https://github.com/Koruri/Koruri";
    license = licenses.asl20;
    maintainers = with maintainers; [ haruki7049 ];
    platforms = platforms.all;
  };
}
