{ lib, stdenv, fetchFromGitHub, makeWrapper, pkg-config, alsa-lib, dbus, libjack2
, python3Packages , meson, ninja }:

stdenv.mkDerivation rec {
  pname = "a2jmidid";
  version = "9";

  src = fetchFromGitHub {
    owner = "linuxaudio";
    repo = pname;
    rev = version;
    sha256 = "sha256-WNt74tSWV8bY4TnpLp86PsnrjkqWynJJt3Ra4gZl2fQ=";
  };

  nativeBuildInputs = [ pkg-config makeWrapper meson ninja ];
  buildInputs = [ alsa-lib dbus libjack2 ] ++
                (with python3Packages; [ python dbus-python ]);

  postInstall = ''
    wrapProgram $out/bin/a2j_control --set PYTHONPATH $PYTHONPATH
    substituteInPlace $out/bin/a2j --replace "a2j_control" "$out/bin/a2j_control"
  '';

  meta = with lib; {
    description = "Daemon for exposing legacy ALSA sequencer applications in JACK MIDI system";
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = [ "i686-linux" "x86_64-linux" "aarch64-linux" ];
  };
}
