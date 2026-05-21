{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "musl-fts";
  version = "1.2.7";

  src = fetchFromGitHub {
    owner = "void-linux";
    repo = "musl-fts";
    rev = "v${finalAttrs.version}";
    sha256 = "Azw5qrz6OKDcpYydE6jXzVxSM5A8oYWAztrHr+O/DOE=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/void-linux/musl-fts";
    description = "Implementation of fts(3) for musl-libc";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.pjjw ];
  };
})
