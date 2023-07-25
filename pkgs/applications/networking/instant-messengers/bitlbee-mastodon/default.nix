{ lib, fetchgit, stdenv, bitlbee, autoreconfHook, pkg-config, glib }:

stdenv.mkDerivation rec {
  pname = "bitlbee-mastodon";
  version = "1.4.5";

  src = fetchgit {
    url = "https://alexschroeder.ch/cgit/bitlbee-mastodon";
    rev = "v${version}";
    sha256 = "sha256-8vmq/YstuBYUxe00P4NrxD/eMYI++R9uvn1sCcMTr7I=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ bitlbee ];

  preConfigure = ''
    export BITLBEE_PLUGINDIR=$out/lib/bitlbee
    export BITLBEE_DATADIR=$out/share/bitlbee
  '';

  meta = with lib; {
    description = "Bitlbee plugin for Mastodon";
    homepage = "https://alexschroeder.ch/cgit/bitlbee-mastodon/about";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ jpotier ];
    platforms = lib.platforms.linux;
  };
}
