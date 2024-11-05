{ lib, stdenv, fetchFromGitHub, scons, pkg-config, wrapGAppsHook3
, glfw3, gtk3, libpng }:

stdenv.mkDerivation (finalAttrs: {
  pname = "goxel";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "guillaumechereau";
    repo = "goxel";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mNSkQisWL3wXb+IsClWFTMbpeiRC4xteePXNP+GkUnU=";
  };

  nativeBuildInputs = [ scons pkg-config wrapGAppsHook3 ];
  buildInputs = [ glfw3 gtk3 libpng ];

  dontUseSconsBuild = true;
  dontUseSconsInstall = true;

  makeFlags = [ "PREFIX=$(out)" ];

  buildFlags = [ "release" ];

  meta = with lib; {
    description = "Open Source 3D voxel editor";
    mainProgram = "goxel";
    homepage = "https://guillaumechereau.github.io/goxel/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tilpner fgaz ];
  };
})
