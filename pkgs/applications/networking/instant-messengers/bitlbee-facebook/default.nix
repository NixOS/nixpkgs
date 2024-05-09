{ lib, fetchFromGitHub, stdenv, bitlbee, autoconf, automake, libtool, pkg-config, json-glib }:

stdenv.mkDerivation rec {
  pname = "bitlbee-facebook";
  version = "1.2.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "bitlbee";
    repo = "bitlbee-facebook";
    sha256 = "1qiiiq17ybylbhwgbwsvmshb517589r8yy5rsh1rfaylmlcxyy7z";
  };

  nativeBuildInputs = [ autoconf automake libtool pkg-config ];

  buildInputs = [ bitlbee json-glib ];

  preConfigure = ''
    export BITLBEE_PLUGINDIR=$out/lib/bitlbee
    ./autogen.sh
  '';

  meta = with lib; {
    description = "The Facebook protocol plugin for bitlbee";
    homepage = "https://github.com/bitlbee/bitlbee-facebook";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ toonn ];
    platforms = platforms.linux;
  };
}
