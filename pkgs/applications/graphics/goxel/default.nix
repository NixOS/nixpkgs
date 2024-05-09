{ lib, stdenv, fetchFromGitHub, scons, pkg-config, wrapGAppsHook3
, glfw3, gtk3, libpng }:

stdenv.mkDerivation (finalAttrs: {
  pname = "goxel";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "guillaumechereau";
    repo = "goxel";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ueA0YW2n/DXd9AytDzfPtvtXbvuUm4VDwcdvHWObKxc=";
  };

  nativeBuildInputs = [ scons pkg-config wrapGAppsHook3 ];
  buildInputs = [ glfw3 gtk3 libpng ];

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
    mainProgram = "goxel";
    homepage = "https://guillaumechereau.github.io/goxel/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tilpner fgaz ];
  };
})
