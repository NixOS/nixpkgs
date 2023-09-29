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
, waylandSupport ? false
}:

buildGoModule rec {
  pname = "supersonic" + lib.optionalString waylandSupport "-wayland";
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

  # go-glfw doesn't support both X11 and Wayland in single build
  tags = lib.optionals waylandSupport [ "wayland" ];

  buildInputs = [
    libglvnd
    mpv
    xorg.libXxf86vm
    xorg.libX11
  ] ++ (glfw3.override { inherit waylandSupport; }).buildInputs;

  postInstall = ''
    for dimension in 128 256 512;do
        dimensions=''${dimension}x''${dimension}
        mkdir -p $out/share/icons/hicolor/$dimensions/apps
        cp res/appicon-$dimension.png $out/share/icons/hicolor/$dimensions/apps/${meta.mainProgram}.png
    done
  '' + lib.optionalString waylandSupport ''
    mv $out/bin/supersonic $out/bin/${meta.mainProgram}
  '';

  desktopItems = [
    (makeDesktopItem {
      name = meta.mainProgram;
      exec = meta.mainProgram;
      icon = meta.mainProgram;
      desktopName = "Supersonic" + lib.optionalString waylandSupport " (Wayland)";
      genericName = "Subsonic Client";
      comment = meta.description;
      type = "Application";
      categories = [ "Audio" "AudioVideo" ];
    })
  ];

  meta = with lib; {
    mainProgram = "supersonic" + lib.optionalString waylandSupport "-wayland";
    description = "A lightweight cross-platform desktop client for Subsonic music servers";
    homepage = "https://github.com/dweymouth/supersonic";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ zane sochotnicky ];
  };
}
