{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libminc,
  netpbm,
}:

stdenv.mkDerivation rec {
  pname = "bicpl";
  version = "unstable-2024-05-14";

  # master is not actively maintained, using develop and develop-apple branches
  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = pname;
    rev = "7e1e791483cf135fe29b8eecd7a360aa892823ae";
    hash = "sha256-SvbtPUfEYp3IGivG+5yFdJF904miyMk+s15zwW7e7b4=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libminc
    netpbm
  ];

  cmakeFlags = [ "-DLIBMINC_DIR=${libminc}/lib/cmake" ];

  doCheck = false;
  # internal_volume_io.h: No such file or directory

  meta = {
    homepage = "https://github.com/BIC-MNI/bicpl";
    description = "Brain Imaging Centre programming library";
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = lib.platforms.unix;
    license = with lib.licenses; [
      hpndUc
      gpl3Plus
    ];
  };
}
