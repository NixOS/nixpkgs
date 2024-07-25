{ lib, stdenv, fetchurl, alsa-lib, jack2, minixml, pkg-config }:

stdenv.mkDerivation rec {
  pname = "aj-snapshot" ;
  version = "0.9.9";

  src = fetchurl {
    url = "mirror://sourceforge/aj-snapshot/aj-snapshot-${version}.tar.bz2";
    sha256 = "0z8wd5yvxdmw1h1rj6km9h01xd4xmp4d86gczlix7hsc7zrf0wil";
  };

  doCheck = false;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsa-lib minixml jack2 ];

  meta = with lib; {
    description = "Tool for storing/restoring JACK and/or ALSA connections to/from cml files";
    longDescription = ''
    Aj-snapshot is a small program that can be used to make snapshots of the connections made between JACK and/or ALSA clients.
    Because JACK can provide both audio and MIDI support to programs, aj-snapshot can store both types of connections for JACK.
    ALSA, on the other hand, only provides routing facilities for MIDI clients.
    You can also run aj-snapshot in daemon mode if you want to have your connections continually restored.
    '';

    homepage = "http://aj-snapshot.sourceforge.net/";
    license = licenses.gpl2;
    maintainers = [ maintainers.mrVanDalo ];
    platforms = platforms.all;
    mainProgram = "aj-snapshot";
  };
}
