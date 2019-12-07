{ config, stdenv, fetchurl, zlib, pkgconfig, mpg123, libogg, libvorbis, portaudio, libsndfile, flac
, usePulseAudio ? config.pulseaudio or false, libpulseaudio }:

let
  version = "0.4.9";
in stdenv.mkDerivation {
  pname = "openmpt123";
  inherit version;

  src = fetchurl {
    url = "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-${version}+release.autotools.tar.gz";
    sha256 = "02kjwwh9d9i4rnfzqzr18pvcklc46yrs9mvdmjqx7kxg3c28hkqm";
  };

  enableParallelBuilding = true;
  doCheck = true;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ zlib mpg123 libogg libvorbis portaudio libsndfile flac ]
  ++ stdenv.lib.optional usePulseAudio libpulseaudio;

  configureFlags = stdenv.lib.optional (!usePulseAudio) [ "--without-pulseaudio" ];

  meta = with stdenv.lib; {
    description = "A cross-platform command-line based module file player";
    homepage = https://lib.openmpt.org/libopenmpt/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ gnidorah ];
    platforms = platforms.linux;
  };
}
