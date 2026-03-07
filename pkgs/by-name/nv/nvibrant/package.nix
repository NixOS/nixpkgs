{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nvibrant";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "Tremeschin";
    repo = "nvibrant";
    rev = "v${finalAttrs.version}";
    hash = "sha256-o3IS8F8uKFfr0KnzkxvctBzJDP3Qpwu58LkXXGd5X8c=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  mesonBuildType = "release";

  meta = with lib; {
    description = "Configure NVIDIA's Digital Vibrance on Wayland";
    homepage = "https://github.com/Tremeschin/nvibrant";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.mikaeladev ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "nvibrant";
  };
})
