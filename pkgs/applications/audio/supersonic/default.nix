{ lib
, buildGoModule
, fetchFromGitHub
, makeDesktopItem
, copyDesktopItems
, pkg-config
, xorg
, libglvnd
, mpv
, glfw3
}:

buildGoModule rec {
  pname = "supersonic";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "dweymouth";
    repo = "supersonic";
    rev = "v${version}";
    hash = "sha256-4SLAUqLMoUxTSi4I/QeHqudO62Gmhpm1XbCGf+3rPlc=";
  };

  vendorHash = "sha256-6Yp5OoybFpoBuIKodbwnyX3crLCl8hJ2r4plzo0plsY=";

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
  ];

  buildInputs = [
    libglvnd
    mpv
    xorg.libXxf86vm
  ] ++ glfw3.buildInputs;

  postInstall = ''
    mkdir -p $out/share/icons/hicolor/{128x128,256x256,512x512}/apps

    for i in 128 256 512; do
      install -D $src/res/appicon-$i.png $out/share/icons/hicolor/''${i}x''${i}/apps/${meta.mainProgram}.png
    done
  '';

  desktopItems = [
    (makeDesktopItem {
      name = meta.mainProgram;
      exec = meta.mainProgram;
      icon = meta.mainProgram;
      desktopName = "Supersonic";
      genericName = "Subsonic Client";
      comment = meta.description;
      type = "Application";
      categories = [ "Audio" "AudioVideo" ];
    })
  ];

  meta = with lib; {
    mainProgram = "supersonic";
    description = "A lightweight cross-platform desktop client for Subsonic music servers";
    homepage = "https://github.com/dweymouth/supersonic";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ zane ];
  };
}
