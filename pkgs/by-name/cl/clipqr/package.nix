{
  buildGoModule,
  copyDesktopItems,
  fetchFromGitLab,
  lib,
  libGL,
  libx11,
  libxcursor,
  libxext,
  libxi,
  libxinerama,
  libxrandr,
  libxxf86vm,
  makeDesktopItem,
  libgbm,
  pkg-config,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "clipqr";
  version = "1.3.0";

  src = fetchFromGitLab {
    owner = "imatt-foss";
    repo = "clipqr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-iuA6RqclMm1CWaiM1kpOpgfYvKaYGOIwFQkLr/nCL5M=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  buildInputs = [
    libGL
    libx11
    libxcursor
    libxext
    libxi
    libxinerama
    libxrandr
    libxxf86vm
    libgbm
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

  meta = {
    description = "Scan QR codes on screen and from camera, the result is in your clipboard";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MatthieuBarthel ];
    homepage = "https://gitlab.com/imatt-foss/clipqr";
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "clipqr";
  };
})
