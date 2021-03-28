{ lib, fetchFromGitHub, fetchpatch, stdenv, bitlbee, autoconf, automake, libtool, pkg-config, json-glib }:

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
  #       these lines should be removed when this happens.
  patches = [
    (fetchpatch {
        name = "FB_ORCA_AGENT_version_bump.patch";
        url = "https://github.com/bitlbee/bitlbee-facebook/commit/49ea312d98b0578b9b2c1ff759e2cfa820a41f4d.patch";
        sha256 = "0nzyyg8pw4f2jcickcpxq7r2la5wgl7q6iz94lhzybrkhss5753d";
      }
    )
  ];

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
