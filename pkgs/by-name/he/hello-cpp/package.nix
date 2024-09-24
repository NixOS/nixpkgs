{
  cmake,
  lib,
  ninja,
  stdenv,
}:

stdenv.mkDerivation {
  name = "hello-cpp";
  src = ./src;
  nativeBuildInputs = [ cmake ninja ];
  meta = {
    description = "Basic sanity check that C++ and cmake infrastructure are working";
    platforms = lib.platforms.all;
    maintainers = stdenv.meta.maintainers or [];
    mainProgram = "hello-cpp";
  };
}
