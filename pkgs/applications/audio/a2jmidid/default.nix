{ stdenv, fetchFromRepoOrCz, fetchpatch, makeWrapper, pkgconfig, alsaLib, dbus, libjack2
, wafHook
, python2Packages}:

let
  inherit (python2Packages) python dbus-python;
in stdenv.mkDerivation rec {
  name = "a2jmidid-${version}";
  version = "8";

  src = fetchFromRepoOrCz {
    repo = "a2jmidid";
    rev = "7383d268c4bfe85df9f10df6351677659211d1ca";
    sha256 = "0j22la0zjixcw55x8ccfpabnv1ljl487s0b9yaj4ykrv1731wr5y";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper wafHook ];
  buildInputs = [ alsaLib dbus libjack2 python dbus-python ];

  patches = [
    (fetchpatch {
      url = https://repo.or.cz/a2jmidid.git/patch/24e3b8e543256ae8fdfb4b75eb9fd775f07c46e2;
      sha256 = "1nxrvnhxlgqc9wbxnp1gnpw4wjyzxvymwcg1gh2nqzmssgfykfkc";
    })
    (fetchpatch {
      url = https://repo.or.cz/a2jmidid.git/patch/7f82da7eb2f540a94db23331be98d42a58ddc269;
      sha256 = "1nab9zf0agbcj5pvhl90pz0cx1d204d4janqflc5ymjhy8jyrsdv";
    })
  ];

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
