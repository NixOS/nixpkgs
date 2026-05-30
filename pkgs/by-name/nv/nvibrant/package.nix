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
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "Tremeschin";
    repo = "nvibrant";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pEOZQjfAlNWUEbrfFEuPAaabWjilvMaAjpdJedNPDs0=";
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
