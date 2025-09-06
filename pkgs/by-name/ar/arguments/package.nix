{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "arguments";
  version = "unstable-2015-11-30";

  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = "arguments";
    rev = "b3aad97f6b6892cb8733455d0d448649a48fa108";
    hash = "sha256-2uz/Mi7Jp7NzfWihI/NmOh9vOmEly9r2+NTJwEOlKKs=";
  };

  nativeBuildInputs = [ cmake ];

  #cmakeFlags = [ "-DLIBMINC_DIR=${libminc}/lib" "-DBICPL_DIR=${bicpl}/lib" ];

  doCheck = false;
  # internal_volume_io.h: No such file or directory

  meta = {
    homepage = "https://github.com/BIC-MNI/arguments";
    description = "Library for argument handling for MINC programs";
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
  };
}
