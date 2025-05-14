{
  lib,
  pkgs,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "nvtop";
  version = "3.2.0";

  src = pkgs.fetchFromGitHub {
    owner = "Syllo";
    repo = "nvtop";
    tag = "${version}";
    hash = "sha256-8iChT55L2NSnHg8tLIry0rgi/4966MffShE0ib+2ywc=";
  };

  buildInputs = with pkgs; [
    cmake
    ncurses
    systemd
    udev
    libdrm
  ];

  configurePhase = ''
    mkdir -p build
    mkdir $out
    cd build
    cmake .. -DNVIDIA_SUPPORT=ON -DAMDGPU_SUPPORT=ON -DINTEL_SUPPORT=ON -DCMAKE_INSTALL_PREFIX=$out
  '';

  meta = {
    description = "GPU & Accelerator process monitoring for AMD, Apple, Huawei, Intel, NVIDIA and Qualcomm ";
    homepage = "https://github.com/Syllo/nvtop";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ Tebro ];
  };
}
