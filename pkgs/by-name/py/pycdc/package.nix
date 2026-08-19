{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "pycdc";
  version = "0-unstable-2024-10-13";

  src = fetchFromGitHub {
    owner = "zrax";
    repo = "pycdc";
    rev = "5e1c4037a96b966e4e6728c55b2d7ee8076a13c3";
    hash = "sha256-c/mfM2I8Rw136aQ3IAQOkkrOEtZ5LC/xKuWXzCItW2w=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "C++ python bytecode disassembler and decompiler";
    homepage = "https://github.com/zrax/pycdc";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ msm ];
    mainProgram = "pycdc";
  };
}
