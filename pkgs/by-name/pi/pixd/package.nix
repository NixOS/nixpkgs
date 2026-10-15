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
    hash = "sha256-r3UyGBmzOF9ZTM/yhonUKX90TcU9M/dn5bu8moZes+4=";
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
