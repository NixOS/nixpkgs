{ config, stdenv, fetchurl, zlib, pkgconfig, mpg123, libogg, libvorbis, portaudio, libsndfile, flac
, usePulseAudio ? config.pulseaudio or false, libpulseaudio }:

let
  version = "0.5.0";
in stdenv.mkDerivation {
  pname = "openmpt123";
  inherit version;

  src = fetchurl {
    url = "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-${version}+release.autotools.tar.gz";
    sha256 = "0zl3djy9z7cpqk8g8pxrzmmikxsskb0y5qdabg6c683j7x5abjs3";
  };

  enableParallelBuilding = true;
  doCheck = true;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ zlib mpg123 libogg libvorbis portaudio libsndfile flac ]
  ++ stdenv.lib.optional usePulseAudio libpulseaudio;

  configureFlags = stdenv.lib.optional (!usePulseAudio) "--without-pulseaudio";

  meta = with stdenv.lib; {
    description = "A cross-platform command-line based module file player";
    homepage = "https://lib.openmpt.org/libopenmpt/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gnidorah ];
    platforms = platforms.linux;
  };
}
