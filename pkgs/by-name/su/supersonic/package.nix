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
}:

buildGoModule (finalAttrs: {
  pname = "supersonic";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "dweymouth";
    repo = "supersonic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ynw/NLDk2AVmn30llFtt/A9hEheUZ+/VZqXOIdiUSxQ=";
  };

  vendorHash = "sha256-W5Uwma72lqJB+QHkSasi7WArsYlfXLVPph9TlDSxFEk=";

  # "go mod vendor" fails to build; go-gl/glfw fails with an error like:
  # xdg-shell-client-protocol.h: No such file or directory
  proxyVendor = true;

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    desktopToDarwinBundle
  ];

  tags = [ "migrated_fynedo" ];

  buildInputs = [
    libglvnd
    mpv-unwrapped
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libxxf86vm
    libx11
    libxrandr
    libxinerama
    libxcursor
    libxi
    libxext
    wayland
    wayland-protocols
    libxkbcommon
  ];

  postInstall = ''
    for dimension in 128 256 512;do
        dimensions=''${dimension}x''${dimension}
        mkdir -p $out/share/icons/hicolor/$dimensions/apps
        cp res/appicon-$dimension.png $out/share/icons/hicolor/$dimensions/apps/${finalAttrs.meta.mainProgram}.png
    done
  '';

  desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.meta.mainProgram;
      exec = finalAttrs.meta.mainProgram;
      icon = finalAttrs.meta.mainProgram;
      desktopName = "Supersonic";
      genericName = "Subsonic Client";
      comment = finalAttrs.meta.description;
      type = "Application";
      categories = [
        "Audio"
        "AudioVideo"
      ];
    })
  ];

  meta = {
    mainProgram = "supersonic";
    description = "Lightweight cross-platform desktop client for Subsonic music servers";
    homepage = "https://github.com/dweymouth/supersonic";
    changelog = "https://github.com/dweymouth/supersonic/releases/tag/${finalAttrs.src.tag}";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      zane
      sochotnicky
      toasteruwu
    ];
  };
})
