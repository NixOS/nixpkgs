{ lib, fetchFromGitHub, stdenv, bitlbee, autoconf, automake, libtool, pkg-config, glib, json-glib }:

with lib;
stdenv.mkDerivation rec {
  pname = "bitlbee-facebook";
  version = "1.2.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "bitlbee";
    repo = "bitlbee-facebook";
    sha256 = "1yjhjhk3jzjip13lq009vlg84lm2lzwhac5jy0aq3vkcz6rp94rc";
  };

  # TODO: This patch should be included with the next release after v1.2.1
  #       these lines and the patch should be removed when this happens.
  patches = [ ./0001-Bump-the-FB_ORCA_AGENT-version-once-again-208.patch ];

  nativeBuildInputs = [ autoconf automake libtool pkg-config ];

  buildInputs = [ bitlbee json-glib ];

  preConfigure = ''
    export BITLBEE_PLUGINDIR=$out/lib/bitlbee
    ./autogen.sh
  '';

  meta = {
    description = "The Facebook protocol plugin for bitlbee";

    homepage = "https://github.com/bitlbee/bitlbee-facebook";
    license = licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
