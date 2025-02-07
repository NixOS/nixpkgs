{
  stdenv,
  lib,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  obs-studio,
  libGL,
  libX11,
}:

stdenv.mkDerivation rec {
  pname = "obs-nvfbc";
  version = "0.0.7";

  src = fetchFromGitLab {
    owner = "fzwoch";
    repo = "obs-nvfbc";
    rev = "v${version}";
    hash = "sha256-AJ3K0O1vrixskn+/Tpg7LsgRO8N4sgDo1Y6gg3CwGVo=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];
  buildInputs = [
    obs-studio
    libGL
    libX11
  ];

  meta = with lib; {
    description = "OBS Studio source plugin for NVIDIA FBC API";
    homepage = "https://gitlab.com/fzwoch/obs-nvfbc";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ babbaj ];
    platforms = [ "x86_64-linux" ];
  };
}
