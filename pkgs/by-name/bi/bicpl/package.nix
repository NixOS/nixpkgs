{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libminc,
  netpbm,
}:

stdenv.mkDerivation {
  pname = "bicpl";
  version = "0-unstable-2025-10-24";

  # master is not actively maintained, using develop and develop-apple branches
  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = "bicpl";
    rev = "dc9828841e38c6b7c523f3ab8a4c23eeb9e4272b";
    hash = "sha256-wU/Qmtk6rbwxYqealV2On7W0schrYH85oKIUCpT4IXQ=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libminc
    netpbm
  ];

  cmakeFlags = [ "-DLIBMINC_DIR=${libminc}/lib/cmake" ];

  doCheck = false;
  # internal_volume_io.h: No such file or directory

  meta = with lib; {
    homepage = "https://github.com/BIC-MNI/bicpl";
    description = "Brain Imaging Centre programming library";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = with licenses; [
      hpndUc
      gpl3Plus
    ];
  };
}
