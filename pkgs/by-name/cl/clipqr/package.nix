{
  buildGoModule,
  copyDesktopItems,
  fetchFromGitLab,
  lib,
  libGL,
  libdecor,
  libgbm,
  libx11,
  libxcursor,
  libxext,
  libxi,
  libxinerama,
  libxkbcommon,
  libxrandr,
  libxxf86vm,
  makeDesktopItem,
  makeWrapper,
  pkg-config,
  wayland,
  wl-clipboard,
}:

buildGoModule (finalAttrs: {
  pname = "clipqr";
  version = "1.4.0";

  src = fetchFromGitLab {
    owner = "imatt-foss";
    repo = "clipqr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DC6zc1Qe/z7ihuvdawb8bj5MefYGgt7HAV5dWTjeHZc=";
  };

  vendorHash = "sha256-MrXMbavff6CEKVbL+Mx8hICYB9sZQcvAhnu2X4sVvVw=";

  tags = [ "wayland" ];

  ldflags = [
    "-s"
    "-w"
  ];

  buildInputs = [
    libGL
    libgbm
    libx11
    libxcursor
    libxext
    libxi
    libxinerama
    libxkbcommon
    libxrandr
    libxxf86vm
    wayland
  ];

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    pkg-config
  ];

  postInstall = ''
    install -Dm644 icon.svg $out/share/icons/hicolor/scalable/apps/clipqr.svg

    wrapProgram $out/bin/clipqr \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libdecor ]} \
      --prefix PATH : ${lib.makeBinPath [ wl-clipboard ]}
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
    platforms = lib.platforms.linux;
    mainProgram = "clipqr";
  };
})
