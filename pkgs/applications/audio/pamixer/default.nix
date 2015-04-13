{ stdenv, fetchurl, unzip, pulseaudio, boost }:

let
  tag = "1.2.1";
in

stdenv.mkDerivation rec {

  name = "pamixer-${tag}";

  src = fetchurl {
    url = "https://github.com/cdemoulins/pamixer/archive/1.2.1.zip";
    sha256 = "2e66bb9810c853ae2d020d5e6eeb2b68cd43c6434b2298ccc423d9810f0cbd6a";
  };

  buildInputs = [ unzip pulseaudio boost ];

  installPhase = ''
    mkdir -p $out/bin
    cp pamixer $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Like amixer but for pulseaudio";
    longDescription = "Features:
      - Get the current volume of the default sink, the default source or a selected one by his id
      - Set the volume for the default sink, the default source or any other device
      - List the sinks
      - List the sources
      - Increase / Decrease the volume for a device
      - Mute or unmute a device";
    homepage = https://github.com/cdemoulins/pamixer;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers._1126 ];
  };
}
