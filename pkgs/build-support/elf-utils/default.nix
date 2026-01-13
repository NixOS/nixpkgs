{ stdenv, meson, ninja }:

stdenv.mkDerivation {
  name = "build-support-elf-utils";
  src = ./src;

  nativeBuildInputs = [ meson ninja ];
}
