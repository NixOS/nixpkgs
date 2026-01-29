{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libX11,
  libXinerama,
  imlib2,
}:

stdenv.mkDerivation (finalAttrs: {

  pname = "bgs";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "Gottox";
    repo = "bgs";
    rev = "v${finalAttrs.version}";
    sha256 = "V8GP+xLSiCvaYZt8Bi3/3KlTBaGnMYQUeNCHwH6Ejzo=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libX11
    libXinerama
    imlib2
  ];

  preConfigure = ''sed -i "s@PREFIX = /usr/local@PREFIX = $out@g" config.mk'';

  meta = {
    description = "Extremely fast and small background setter for X";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pSub ];
    mainProgram = "bgs";
  };
})
