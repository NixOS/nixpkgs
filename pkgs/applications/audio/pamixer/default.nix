{ stdenv, fetchurl, boost, libpulseaudio }:

stdenv.mkDerivation rec {

  name = "pamixer-${version}";
  version = "1.3.1";

  src = fetchurl {
    url = "https://github.com/cdemoulins/pamixer/archive/${version}.tar.gz";
    sha256 = "1lsvb4xk1dq762w9c0jn7xvj3v1lzppql9mj1b55fhzdypbrkm6x";
  };

  buildInputs = [ boost libpulseaudio ];

  installPhase = ''
    mkdir -p $out/bin
    cp pamixer $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Pulseaudio command line mixer";
    longDescription = ''
      Features:
        - Get the current volume of the default sink, the default source or a selected one by his id
        - Set the volume for the default sink, the default source or any other device
        - List the sinks
        - List the sources
        - Increase / Decrease the volume for a device
        - Mute or unmute a device
    '';
    homepage = https://github.com/cdemoulins/pamixer;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
