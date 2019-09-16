{ fetchgit, stdenv, bitlbee, autoreconfHook, pkgconfig, glib }:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "bitlbee-mastodon";
  version = "1.4.2";

  src = fetchgit {
    url = "https://alexschroeder.ch/cgit/bitlbee-mastodon";
    rev = "v${version}";
    sha256 = "04rakgr1pfsg1vhfwlfbggbzw249j7dmk88xrsnf3n84c5ccdyas";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ bitlbee glib ];

  preConfigure = ''
    export BITLBEE_PLUGINDIR=$out/lib/bitlbee
    export BITLBEE_DATADIR=$out/share/bitlbee
    ./autogen.sh
  '';

  meta = {
    description = "Bitlbee plugin for Mastodon";
    homepage = "https://alexschroeder.ch/cgit/bitlbee-mastodon/about";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ jpotier ];
    platforms = stdenv.lib.platforms.linux;
  };
}
