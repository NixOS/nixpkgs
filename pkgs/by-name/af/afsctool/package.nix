{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  git,
  zlib,
  sparsehash,
}:

stdenv.mkDerivation rec {
  pname = "afsctool";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "RJVB";
    repo = "afsctool";
    tag = "v${version}";
    hash = "sha256-cZ0P9cygj+5GgkDRpQk7P9z8zh087fpVfrYXMRRVUAI=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    git
  ];
  buildInputs = [
    zlib
    sparsehash
  ];

  meta = {
    description = "Utility that allows end-users to leverage HFS+/APFS compression";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ viraptor ];
    platforms = lib.platforms.darwin;
    homepage = "https://github.com/RJVB/afsctool";
  };
}
