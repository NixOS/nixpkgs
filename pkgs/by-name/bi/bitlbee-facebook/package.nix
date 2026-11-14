{
  lib,
  fetchFromGitHub,
  stdenv,
  bitlbee,
  autoconf,
  automake,
  libtool,
  pkg-config,
  json-glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bitlbee-facebook";
  version = "1.2.2";

  src = fetchFromGitHub {
    rev = "v${finalAttrs.version}";
    owner = "bitlbee";
    repo = "bitlbee-facebook";
    hash = "sha256-/3jfGa3UK5cD1Ll4j3JC5YSyoK5b8/U4XNQvfwKOMeI=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
  ];

  buildInputs = [
    bitlbee
    json-glib
  ];

  preConfigure = ''
    export BITLBEE_PLUGINDIR=$out/lib/bitlbee
    ./autogen.sh
  '';

  meta = {
    description = "Facebook protocol plugin for bitlbee";
    homepage = "https://github.com/bitlbee/bitlbee-facebook";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ toonn ];
    platforms = lib.platforms.linux;
  };
})
