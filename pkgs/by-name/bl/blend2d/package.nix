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
  version = "0.10";

  src = fetchFromGitHub {
    owner = "blend2d";
    repo = "blend2d";
    rev = "452d549751188b04367b5af46c040cb737f5f76c";
    hash = "sha256-LDhnXsp/V1A3YqVyjBVaL7/V6Nhts/1E9hRhl2P293o=";
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
