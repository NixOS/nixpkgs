{
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "id3";
  version = "0.81";

  src = fetchFromGitHub {
    owner = "squell";
    repo = "id3";
    rev = "${version}";
    sha256 = "+h1wwgTB7CpbjyUAK+9BNRhmy83D+1I+cZ70E1m3ENk=";
  };

  makeFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    description = "Portable command-line mass tagger";
    homepage = "https://squell.github.io/id3/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jecaro ];
    platforms = with platforms; unix;
    mainProgram = "id3";
  };
}
