{
  lib,
  stdenv,
  fetchFromGitHub,
  gzip,
  libvorbis,
  libmad,
  SDL2,
  SDL2_mixer,
  libpng,
  alsa-lib,
  gnutls,
  libjpeg,
  vulkan-loader,
  vulkan-headers,
  speex,
  libopus,
  libxscrnsaver,
  libxcb,
  libxrandr,
  libxcursor,
  libGL,
}@attrs:
import ./generic.nix (
  rec {
    pname = "fteqw";

    buildFlags = [ "m-rel" ];

    nativeBuildInputs = [
      vulkan-headers
    ];

    buildInputs = [
      gzip
      libvorbis
      libmad
      SDL2
      SDL2_mixer
      libGL
      libpng
      alsa-lib
      gnutls
      libjpeg
      vulkan-loader
      speex
      libopus
      libxcb
      libxrandr
      libxcursor
      libxscrnsaver
    ];

    postFixup = ''
      patchelf $out/bin/${pname} \
        --add-needed ${SDL2}/lib/libSDL2.so \
        --add-needed ${libGL}/lib/libGLX.so \
        --add-needed ${libGL}/lib/libGL.so \
        --add-needed ${lib.getLib gnutls}/lib/libgnutls.so \
        --add-needed ${vulkan-loader}/lib/libvulkan.so
    '';

    description = "Hybrid and versatile game engine";
  }
  // attrs
)
