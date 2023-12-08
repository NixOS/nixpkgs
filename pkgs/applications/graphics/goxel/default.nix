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

    for res in $(ls data/icons | sed -e 's/icon//g' -e 's/.png//g'); do
      install -Dm444 data/icons/icon$res.png $out/share/icons/hicolor/''${res}x''${res}/apps/goxel.png
    done

    install -Dm444 snap/gui/goxel.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/goxel.desktop \
      --replace 'Icon=''${SNAP}/icon.png' 'Icon=goxel'
  '';

  meta = with lib; {
    description = "Open Source 3D voxel editor";
    homepage = "https://guillaumechereau.github.io/goxel/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tilpner fgaz ];
  };
}
