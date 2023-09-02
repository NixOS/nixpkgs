{ lib, pkgs, buildGoModule, fetchFromGitHub, makeDesktopItem, xorg
, forceWayland ? false }:

buildGoModule rec {
  pname = "supersonic" + lib.optionalString forceWayland "-wayland";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "dweymouth";
    repo = "supersonic";
    rev = "v${version}";
    hash = "sha256-4SLAUqLMoUxTSi4I/QeHqudO62Gmhpm1XbCGf+3rPlc=";
  };

  vendorHash = "sha256-6Yp5OoybFpoBuIKodbwnyX3crLCl8hJ2r4plzo0plsY=";

  nativeBuildInputs = with pkgs; [ pkg-config copyDesktopItems ];

  # go-glfw doesn't support both X11 and Wayland in single build
  tags = "" + lib.optionalString forceWayland "wayland";

  buildInputs = with pkgs;
    [ mpv glfw libglvnd ] ++ (with xorg; [
      libXi
      libXxf86vm
      libX11
      libXcursor
      libXrandr
      libXinerama
      xinput
    ]) ++ lib.optionals forceWayland [ wayland wayland-protocols libxkbcommon ];

  postInstall = ''
    for dimension in 128 256 512;do
        dimensions=''${dimension}x''${dimension}
        mkdir -p $out/share/icons/hicolor/$dimensions/apps
        cp res/appicon-$dimension.png $out/share/icons/hicolor/$dimensions/apps/${pname}.png
    done
  '' + lib.optionalString forceWayland ''
    mv $out/bin/supersonic $out/bin/${pname}
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      icon = pname;
      desktopName = "Supersonic" + lib.optionalString forceWayland " (Wayland)";
      comment = meta.description;
      categories = [ "Audio" "AudioVideo" ];
    })
  ];

  meta = with lib; {
    description =
      "A lightweight cross-platform desktop client for Subsonic music servers";
    homepage = "https://github.com/dweymouth/supersonic";
    license = licenses.gpl3Plus;
    platforms = platforms.linux; # Technically MacOS should be supported though
    maintainers = with maintainers; [ sochotnicky ];
  };
}
