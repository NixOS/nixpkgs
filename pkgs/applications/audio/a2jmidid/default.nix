{ stdenv, fetchurl, makeWrapper, pkgconfig, alsaLib, dbus, libjack2
, wafHook
, python2Packages}:

let
  inherit (python2Packages) python dbus-python;
in stdenv.mkDerivation rec {
  name = "a2jmidid-${version}";
  version = "8";

  src = fetchurl {
    url = "https://repo.or.cz/a2jmidid.git/snapshot/7383d268c4bfe85df9f10df6351677659211d1ca.tar.gz";
    sha256 = "06dgf5655znbvrd7fhrv8msv6zw8vk0hjqglcqkh90960mnnmwz7";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper wafHook ];
  buildInputs = [ alsaLib dbus libjack2 python dbus-python ];

  postInstall = ''
    wrapProgram $out/bin/a2j_control --set PYTHONPATH $PYTHONPATH
  '';

  meta = with stdenv.lib; {
    description = "Daemon for exposing legacy ALSA sequencer applications in JACK MIDI system";
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
