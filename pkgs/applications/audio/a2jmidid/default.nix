{ stdenv, fetchurl, fetchpatch, makeWrapper, pkgconfig, alsaLib, dbus, libjack2
, wafHook
, python2Packages}:

let
  inherit (python2Packages) python dbus-python;
in stdenv.mkDerivation {
  pname = "a2jmidid";
  version = "8";

  src = fetchurl {
    url = "https://github.com/linuxaudio/a2jmidid/archive/7383d268c4bfe85df9f10df6351677659211d1ca.tar.gz";
    sha256 = "06dgf5655znbvrd7fhrv8msv6zw8vk0hjqglcqkh90960mnnmwz7";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper wafHook ];
  buildInputs = [ alsaLib dbus libjack2 python dbus-python ];

  patches = [
    (fetchpatch {
      url = "https://github.com/linuxaudio/a2jmidid/commit/24e3b8e543256ae8fdfb4b75eb9fd775f07c46e2.diff";
      sha256 = "1nxrvnhxlgqc9wbxnp1gnpw4wjyzxvymwcg1gh2nqzmssgfykfkc";
    })
    (fetchpatch {
      url = "https://github.com/linuxaudio/a2jmidid/commit/7f82da7eb2f540a94db23331be98d42a58ddc269.diff";
      sha256 = "1nab9zf0agbcj5pvhl90pz0cx1d204d4janqflc5ymjhy8jyrsdv";
    })
    (fetchpatch {
      url = "https://github.com/linuxaudio/a2jmidid/commit/c07775d021a71cb91bf64ce1391cf525415cb060.diff";
      sha256 = "172v9hri03qdqi8a3zsg227k5qxldd8v5bj4jk7fyk5jf50fcxga";
    })
  ];

  postInstall = ''
    wrapProgram $out/bin/a2j_control --set PYTHONPATH $PYTHONPATH
  '';

  meta = with stdenv.lib; {
    description = "Daemon for exposing legacy ALSA sequencer applications in JACK MIDI system";
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = [ "i686-linux" "x86_64-linux" "aarch64-linux" ];
  };
}
