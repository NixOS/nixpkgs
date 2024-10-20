{ lib
, stdenv
, fetchFromGitHub
, ncurses
, taglib
, zlib
}:

stdenv.mkDerivation rec {
  pname = "stag";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "smabie";
    repo = "stag";
    rev = "v${version}";
    hash = "sha256-IWb6ZbPlFfEvZogPh8nMqXatrg206BTV2DYg7BMm7R4=";
  };

  buildInputs = [
    ncurses
    taglib
    zlib
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv stag $out/bin/stag
    runHook postInstall
  '';

  meta = with lib; {
    description = "Public domain utf8 curses based audio file tagger";
    homepage = "https://github.com/smabie/stag";
    license = with licenses; [ publicDomain ];
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
