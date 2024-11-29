{ lib, mkDerivation }:

mkDerivation {
  path = "lib/libossaudio";
  meta.platforms = lib.platforms.netbsd;
}
