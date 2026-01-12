{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  pkg-config,
  desktopToDarwinBundle,
  libxxf86vm,
  libxrandr,
  libxi,
  libxinerama,
  libxext,
  libxcursor,
  libx11,
  wayland,
  wayland-protocols,
  libxkbcommon,
  libglvnd,
  mpv-unwrapped,
  waylandSupport ? false,
}:

buildGoModule rec {
  pname = "supersonic" + lib.optionalString waylandSupport "-wayland";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "dweymouth";
    repo = "supersonic";
    tag = "v${version}";
    hash = "sha256-/zHqD5e3ZmLoaY3/KJSBtQpF0fzAr2kG1FSauzSduvo=";
  };

  vendorHash = "sha256-hDE0ZKZLAUgztLqxMHtTj8AU0sIAX26bi7eCb2JFo3Q=";

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    desktopToDarwinBundle
  ];

  # go-glfw doesn't support both X11 and Wayland in single build
  tags = [ "migrated_fynedo" ] ++ lib.optionals waylandSupport [ "wayland" ];

  buildInputs = [
    libglvnd
    mpv-unwrapped
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libxxf86vm
    libx11
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && !waylandSupport) [
    libxrandr
    libxinerama
    libxcursor
    libxi
    libxext
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
