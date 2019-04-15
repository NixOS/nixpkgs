{ stdenv, runCommand, fetchFromGitHub, pkgconfig, libsndio, pulseaudio, libtool }:

let
  pulsecore = runCommand "pulseaudio-sources" {} ''
    tar -xf ${pulseaudio.src}
    mv pulseaudio*/src/pulsecore $out
  '';
in stdenv.mkDerivation rec {
  pname = "pulseaudio-module-sndio";
  version = "12.0";

  src = fetchFromGitHub {
    owner = "t6";
    repo = pname;
    rev = version;
    sha256 = "sha256:1xngzqhg01df9fgadv10nmjxpzsykycbxrs241ilpr98x1vf1kn5";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libsndio pulseaudio libtool ];
  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "PULSE_MODDIR=/lib/pulse-${pulseaudio.version}/modules"
  ];

  postPatch = ''
    # upstream has a copy of pulsecore in its repo
    rm -r pulsecore
    ln -s ${pulsecore} pulsecore

    substituteInPlace Makefile --replace '${"\${PULSE_VERSION}"}' ${pulseaudio.version}
  '';

  meta = with stdenv.lib; {
    description = "A module for PulseAudio to support playing to sndio servers.";
    homepage    = https://github.com/t6/pulseaudio-module-sndio;
    maintainers = with maintainers; [ ajs124 ];
    license     = with licenses; [ isc lgpl21Plus ];
  };
}
