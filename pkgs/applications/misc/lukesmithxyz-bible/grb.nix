{ lib
, gawk
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "lukesmithxyz-bible-grb";
  version = "unstable-2022-06-01";

  src = fetchFromGitHub {
    owner = "lukesmithxyz";
    repo = "grb";
    rev = "35a5353ab147b930c39e1ccd369791cc4c27f0df";
    hash = "sha256-hQ21DXnkBJVCgGXQKDR+DjaDC3RXS2pNmSLDoHvHA4E=";
  };

  buildInputs = [ gawk ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Read the Word of God in Greek from your terminal.";
    homepage = "https://lukesmith.xyz/articles/command-line-bibles";
    license = licenses.unlicense;
    platforms = platforms.unix;
    maintainers = [ maintainers.wesleyjrz ];
  };
}
