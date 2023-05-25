{ lib, stdenv, fetchFromGitHub, scons, pkg-config, wrapGAppsHook
, glfw3, gtk3, libpng12 }:

stdenv.mkDerivation rec {
  pname = "goxel";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "guillaumechereau";
    repo = "goxel";
    rev = "v${version}";
    hash = "sha256-taDe5xJU6ijikHaSMDYs/XE2O66X3J7jOKWzbj7hrN0=";
  };

  nativeBuildInputs = [ scons pkg-config wrapGAppsHook ];
  buildInputs = [ glfw3 gtk3 libpng12 ];

  buildPhase = ''
    make release
  '';

  installPhase = ''
    install -D ./goxel $out/bin/goxel
  '';

  meta = with lib; {
    description = "Open Source 3D voxel editor";
    homepage = "https://guillaumechereau.github.io/goxel/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tilpner fgaz ];
  };
}
