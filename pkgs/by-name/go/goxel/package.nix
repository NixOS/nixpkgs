{
  lib,
  stdenv,
  fetchFromGitHub,
  scons,
  pkg-config,
  wrapGAppsHook3,
  glfw3,
  gtk3,
  libpng,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "goxel";
  version = "0.15.1-unstable-2024-12-27";

  src = fetchFromGitHub {
    owner = "guillaumechereau";
    repo = "goxel";
    rev = "60ec064a144295b17dfece85bb778dad19eaa8dc";
    hash = "sha256-H5ErFfYsGmU2KsWJyUoozlrpf/JhgFimMxyFHt+czdg=";
  };

  nativeBuildInputs = [
    scons
    pkg-config
    wrapGAppsHook3
  ];
  buildInputs = [
    glfw3
    gtk3
    libpng
  ];

  dontUseSconsBuild = true;
  dontUseSconsInstall = true;

  makeFlags = [ "PREFIX=$(out)" ];

  buildFlags = [ "release" ];

  meta = {
    description = "Open Source 3D voxel editor";
    mainProgram = "goxel";
    homepage = "https://guillaumechereau.github.io/goxel/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      tilpner
      fgaz
    ];
  };
})
