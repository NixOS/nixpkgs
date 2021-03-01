{ lib, fetchgit, stdenv, bitlbee, autoreconfHook, pkg-config, glib }:

with lib;
stdenv.mkDerivation rec {
  pname = "bitlbee-mastodon";
  version = "1.4.4";

  src = fetchgit {
    url = "https://alexschroeder.ch/cgit/bitlbee-mastodon";
    rev = "v${version}";
    sha256 = "0a8196pyr6bjnqg82zn7jdhiv7xsg4npbpzalla1i2h99j30q8pk";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ bitlbee ];

  preConfigure = ''
    export BITLBEE_PLUGINDIR=$out/lib/bitlbee
    export BITLBEE_DATADIR=$out/share/bitlbee
  '';

  meta = {
    description = "Bitlbee plugin for Mastodon";
    homepage = "https://alexschroeder.ch/cgit/bitlbee-mastodon/about";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ jpotier ];
    platforms = lib.platforms.linux;
  };
}
