{
  lib,
  fetchFromGitHub,
  stdenv,
  bitlbee,
  autoconf,
  automake,
  libtool,
  pkg-config,
  libgcrypt,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.4.2";
  pname = "bitlbee-steam";

  src = fetchFromGitHub {
    rev = "v${finalAttrs.version}";
    owner = "bitlbee";
    repo = "bitlbee-steam";
    sha256 = "121r92mgwv445wwxzh35n19fs5k81ihr0j19k256ia5502b1xxaq";
  };

  nativeBuildInputs = [
    pkg-config
    autoconf
    automake
  ];
  buildInputs = [
    bitlbee
    libtool
    libgcrypt
  ];

  preConfigure = ''
    export BITLBEE_PLUGINDIR=$out/lib/bitlbee
    ./autogen.sh
  '';

  meta = {
    description = "Steam protocol plugin for BitlBee";

    homepage = "https://github.com/jgeboski/bitlbee-steam";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
