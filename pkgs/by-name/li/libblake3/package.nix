{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libblake3";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "BLAKE3-team";
    repo = "BLAKE3";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-2M8OQNmtWwfDcbZYspaxpGz2clpfILru//4+P6dClNw=";
  };

  sourceRoot = finalAttrs.src.name + "/c";

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Official C implementation of BLAKE3";
    homepage = "https://github.com/BLAKE3-team/BLAKE3/tree/master/c";
    license = with lib.licenses; [
      asl20
      cc0
    ];
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
  };
})
