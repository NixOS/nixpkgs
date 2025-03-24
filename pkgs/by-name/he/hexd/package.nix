{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "hexd";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "FireyFly";
    repo = "hexd";
    rev = "v${version}";
    sha256 = "sha256-b/dROBQVPEiMBTcu4MTi6Lf6ChkFZqZrJ1V0j54rrFY=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Colourful, human-friendly hexdump tool";
    homepage = "https://github.com/FireyFly/hexd";
    maintainers = [ maintainers.FireyFly ];
    license = licenses.mit;
    platforms = platforms.unix;
    mainProgram = "hexd";
  };
}
