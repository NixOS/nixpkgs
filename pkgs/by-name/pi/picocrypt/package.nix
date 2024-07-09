{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  darwin,
  copyDesktopItems,
  makeDesktopItem,

  xorg,
  libGL,
  gtk3,
  pkg-config,
  wrapGAppsHook3,
}:

buildGoModule rec {
  pname = "picocrypt";
  version = "1.37";

  src = fetchFromGitHub {
    owner = "Picocrypt";
    repo = "Picocrypt";
    rev = version;
    hash = "sha256-K1zaDHTI9NH2Xn2N1aiE2+wZrfVQBvqIyLTBCZs3Am8=";
  };

  sourceRoot = "${src.name}/src";

  vendorHash = "sha256-lc34GeO8y5XGRk0x6ghw/m/Ew7TDn6MOk4fc2u9UofQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  buildInputs = [
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    xorg.libXinerama
    xorg.libXxf86vm
    libGL.dev
    gtk3
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Kernel
  ];

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
    wrapGAppsHook3
  ];

  CGO_ENABLED = 1;

  postInstall = ''
    mv $out/bin/Picocrypt $out/bin/picocrypt-gui
    install -Dm644 $src/images/key.svg $out/share/icons/hicolor/scalable/apps/picocrypt.svg
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Picocrypt";
      exec = "picocrypt-gui";
      icon = "picocrypt";
      comment = meta.description;
      desktopName = "Picocrypt";
      categories = [ "Utility" ];
    })
  ];

  meta = {
    description = "Very small, very simple, yet very secure encryption tool, written in Go";
    homepage = "https://github.com/Picocrypt/Picocrypt";
    changelog = "https://github.com/Picocrypt/Picocrypt/blob/main/Changelog.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ryand56 ];
    mainProgram = "picocrypt-gui";
  };
}
