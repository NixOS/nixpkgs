{ stdenv, fetchgit, pulseaudio, boost }:

let
  tag = "1.1";
in

stdenv.mkDerivation rec {

  name = "pamixer-${tag}";

  src = fetchgit {
    url = git://github.com/cdemoulins/pamixer;
    rev = "refs/tags/${tag}";
    sha256 = "03r0sbfj85wp6yxa87pjg69ivmk0mxxa2nykr8gf2c607igmb034";
  };

  buildInputs = [ pulseaudio boost boost.lib ];

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
