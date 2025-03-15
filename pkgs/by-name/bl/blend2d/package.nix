{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  asmjit,
}:

stdenv.mkDerivation {
  pname = "blend2d";
  # Note: this is an outdated version for pdf4qt, but vcpkg also uses it
  # See 'Commit Hashes' in https://blend2d.com/download.html for newest
  # If the newest version is needed, we can rename this package.
  version = "0.11.5";

  src = fetchFromGitHub {
    owner = "blend2d";
    repo = "blend2d";
    rev = "7eb92c2946fb35c23c09dbdc6e98d835679d7f82";
    hash = "sha256-PvuRP0BP/Ri1JokWBhw7S1Q0P38+rdyUp+p8MdFVLvI=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ (lib.cmakeFeature "ASMJIT_DIR" (toString asmjit.src)) ];

  meta = {
    description = "2D Vector Graphics Engine Powered by a JIT Compiler";
    homepage = "https://blend2d.com";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.all;
  };
}
