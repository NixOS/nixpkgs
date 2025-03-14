{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "beats";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "j0hax";
    repo = "beats";
    rev = "v${version}";
    sha256 = "1rdvsqrjpily74y8vwch711401585xckb4p41cfwrmj6vf44jhif";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "CC=cc"
  ];

  meta = with lib; {
    homepage = "https://github.com/j0hax/beats";
    license = licenses.gpl3Only;
    description = "Swatch Internet Time implemented as a C program";
    platforms = platforms.all;
    maintainers = [ maintainers.j0hax ];
    mainProgram = "beats";
  };
}
