{ stdenv, fetchFromGitHub, fetchpatch, boost, libpulseaudio }:

stdenv.mkDerivation rec {
  pname = "pamixer";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "cdemoulins";
    repo = "pamixer";
    rev = version;
    sha256 = "1i14550n8paijwwnhksv5izgfqm3s5q2773bdfp6vyqybkll55f7";
  };

  buildInputs = [ boost libpulseaudio ];

  installPhase = ''
    install -Dm755 pamixer -t $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Pulseaudio command line mixer";
    longDescription = ''
      Features:
        - Get the current volume of the default sink, the default source or a selected one by its id
        - Set the volume for the default sink, the default source or any other device
        - List the sinks
        - List the sources
        - Increase / Decrease the volume for a device
        - Mute or unmute a device
    '';
    homepage = "https://github.com/cdemoulins/pamixer";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
