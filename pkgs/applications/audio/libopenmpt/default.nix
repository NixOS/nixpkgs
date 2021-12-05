{ config, lib, stdenv, fetchurl, fetchpatch, zlib, pkg-config, mpg123, libogg
, libvorbis, portaudio, libsndfile, flac
, usePulseAudio ? config.pulseaudio or stdenv.isLinux, libpulseaudio }:

stdenv.mkDerivation rec {
  pname = "libopenmpt";
  version = "0.5.11";

  outputs = [ "out" "lib" "dev" ];

  src = fetchurl {
    url =
      "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-${version}+release.autotools.tar.gz";
    sha256 = "1c54lldr2imjzhlhq5lvwhj7d5794xm97cby9pznr5wdjjay0sa4";
  };

  patches = [
    # Fix pending upstream inclusion for gcc-12 include headers:
    #  https://github.com/OpenMPT/openmpt/pull/8
    (fetchpatch {
      name = "gcc-12.patch";
      url =
        "https://github.com/OpenMPT/openmpt/commit/6e7a43190ef2f9ba0b3efc19b9527261b69ec8f7.patch";
      sha256 = "081m1rf09bbrlg52aihaajmld5dcnwbp6y7zpyik92mm332r330h";
    })
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ zlib mpg123 libogg libvorbis portaudio libsndfile flac ]
    ++ lib.optional usePulseAudio libpulseaudio;

  configureFlags = lib.optional (!usePulseAudio) "--without-pulseaudio";

  doCheck = true;

  meta = with lib; {
    description = "A cross-platform command-line based module file player";
    homepage = "https://lib.openmpt.org/libopenmpt/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.unix;
  };
}
