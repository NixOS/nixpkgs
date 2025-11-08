{
  fetchFromGitHub,
  lib,
  libiconv,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "id3";
  version = "0.81";

  src = fetchFromGitHub {
    owner = "squell";
    repo = "id3";
    rev = version;
    hash = "sha256-+h1wwgTB7CpbjyUAK+9BNRhmy83D+1I+cZ70E1m3ENk=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  makeFlags = [ "prefix=$(out)" ];

  meta = {
    description = "Portable command-line mass tagger";
    homepage = "https://squell.github.io/id3/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ jecaro ];
    platforms = lib.platforms.unix;
    mainProgram = "id3";
  };
}
