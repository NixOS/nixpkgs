{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libminc,
}:

stdenv.mkDerivation {
  pname = "ebtks";
  version = "1.6.40-unstable-2025-05-06";

  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = "EBTKS";
    rev = "7317b54d79bd7d80b5361dc44a7966709d9a8b36";
    hash = "sha256-kp3uPvsIker8918stsVUdMC72A6Jz0K7r5PFDLbWqNo=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libminc ];

  cmakeFlags = [ "-DLIBMINC_DIR=${libminc}/lib/cmake" ];

  meta = {
    homepage = "https://github.com/BIC-MNI/EBTKS";
    description = "Library for working with MINC files";
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = lib.platforms.unix;
    license = lib.licenses.free;
  };
}
