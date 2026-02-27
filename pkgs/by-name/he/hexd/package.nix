{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hexd";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "FireyFly";
    repo = "hexd";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-b/dROBQVPEiMBTcu4MTi6Lf6ChkFZqZrJ1V0j54rrFY=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Colourful, human-friendly hexdump tool";
    homepage = "https://github.com/FireyFly/hexd";
    maintainers = [ lib.maintainers.FireyFly ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "hexd";
  };
})
