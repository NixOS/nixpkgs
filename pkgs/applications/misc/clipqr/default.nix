{ buildGoModule
, copyDesktopItems
, fetchFromGitLab
, lib
, libGL
, libX11
, libXcursor
, libXext
, libXi
, libXinerama
, libXrandr
, makeDesktopItem
, mesa
, pkg-config
, stdenv
}:

buildGoModule rec {
  pname = "clipqr";
<<<<<<< HEAD
  version = "1.0.1";
=======
  version = "1.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    owner = "imatt-foss";
    repo = "clipqr";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-RIzOkJx1eSik+3N6rSh+3LY2VZmbzNYyV5wpLQHFU2A=";
  };

  vendorHash = null;
=======
    sha256 = "sha256-E90nTJtx4GOacu8M7oQBznnSQVDIZatibgKMZEpTUaQ=";
  };

  vendorSha256 = "5kAOSyVbvot4TX/XfRNe1/zZk6fa7pS1Dvn9nz11u3U=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" ];

  buildInputs = [
    libGL
    libX11
    libXcursor
    libXext
    libXi
    libXinerama
    libXrandr
    mesa
  ];

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
  ];

  postInstall = ''
    install -Dm644 icon.svg $out/share/icons/hicolor/scalable/apps/clipqr.svg
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "ClipQR";
      desktopName = "ClipQR";
      exec = "clipqr";
      categories = [ "Utility" ];
      icon = "clipqr";
      comment = "Scan QR codes on screen and from camera";
      genericName = "ClipQR";
    })
  ];

  meta = with lib; {
    description = "Scan QR codes on screen and from camera, the result is in your clipboard";
    license = licenses.mit;
    maintainers = with maintainers; [ MatthieuBarthel ];
    homepage = "https://gitlab.com/imatt-foss/clipqr";
    broken = stdenv.isDarwin;
  };
}
