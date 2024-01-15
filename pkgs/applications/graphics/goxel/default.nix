{ lib, stdenv, fetchFromGitHub, scons, pkg-config, wrapGAppsHook
, glfw3, gtk3, libpng12 }:

stdenv.mkDerivation rec {
  pname = "goxel";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "guillaumechereau";
    repo = "goxel";
    rev = "v${version}";
    hash = "sha256-mB4ln2uIhK/hsX+hUpeZ8H4aumaAUl5vaFkqolJtLRg=";
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
