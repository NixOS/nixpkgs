{ config, lib, stdenv, fetchurl, zlib, pkg-config, mpg123, libogg, libvorbis, portaudio, libsndfile, flac
, usePulseAudio ? config.pulseaudio or false, libpulseaudio }:

let
  version = "0.5.8";
in stdenv.mkDerivation {
  pname = "openmpt123";
  inherit version;

  src = fetchurl {
    url = "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-${version}+release.autotools.tar.gz";
    sha256 = "sha256-KeLCEXS3P2fyul7naAjWLxgrEw5PcE7i2a6Cg5gtis0=";
  };

  enableParallelBuilding = true;
  doCheck = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ zlib mpg123 libogg libvorbis portaudio libsndfile flac ]
  ++ lib.optional usePulseAudio libpulseaudio;

  configureFlags = lib.optional (!usePulseAudio) "--without-pulseaudio";

  meta = with lib; {
    description = "A cross-platform command-line based module file player";
    homepage = "https://lib.openmpt.org/libopenmpt/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
