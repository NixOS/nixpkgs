{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pixd";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "FireyFly";
    repo = "pixd";
    rev = "v${finalAttrs.version}";
    sha256 = "1vmkbs39mg5vwmkzfcrxqm6p8zr9sj4qdwng9icmyf5k34c34xdg";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Colourful visualization tool for binary files";
    homepage = "https://github.com/FireyFly/pixd";
    maintainers = [ lib.maintainers.FireyFly ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "pixd";
  };
})
