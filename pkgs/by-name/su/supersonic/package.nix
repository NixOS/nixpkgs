{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  pkg-config,
  desktopToDarwinBundle,
  xorg,
  wayland,
  wayland-protocols,
  libxkbcommon,
  libglvnd,
  mpv-unwrapped,
  waylandSupport ? false,
}:

buildGoModule rec {
  pname = "supersonic" + lib.optionalString waylandSupport "-wayland";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "dweymouth";
    repo = "supersonic";
    tag = "v${version}";
    hash = "sha256-NzgmkxG58XvaxcIcu9J0VeRjCQ922rJOp3IWX49dgIU=";
  };

  vendorHash = "sha256-dG5D7a13TbVurjqFbKwiZ5IOPul39sCmyPCCzRx0NEY=";

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    desktopToDarwinBundle
  ];

  # go-glfw doesn't support both X11 and Wayland in single build
  tags = lib.optionals waylandSupport [ "wayland" ];

  buildInputs = [
    libglvnd
    mpv-unwrapped
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    xorg.libXxf86vm
    xorg.libX11
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && !waylandSupport) [
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXcursor
    xorg.libXi
    xorg.libXext
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && waylandSupport) [
    wayland
    wayland-protocols
    libxkbcommon
  ];

  postInstall = ''
    for dimension in 128 256 512;do
        dimensions=''${dimension}x''${dimension}
        mkdir -p $out/share/icons/hicolor/$dimensions/apps
        cp res/appicon-$dimension.png $out/share/icons/hicolor/$dimensions/apps/${meta.mainProgram}.png
    done
  ''
  + lib.optionalString waylandSupport ''
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
      categories = [
        "Audio"
        "AudioVideo"
      ];
    })
  ];

  meta = {
    mainProgram = "supersonic" + lib.optionalString waylandSupport "-wayland";
    description = "Lightweight cross-platform desktop client for Subsonic music servers";
    homepage = "https://github.com/dweymouth/supersonic";
    changelog = "https://github.com/dweymouth/supersonic/releases/tag/${src.tag}";
    platforms = lib.platforms.linux ++ lib.optionals (!waylandSupport) lib.platforms.darwin;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      zane
      sochotnicky
    ];
  };
}
