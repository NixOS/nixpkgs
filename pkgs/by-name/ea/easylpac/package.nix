{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  makeDesktopItem,
  copyDesktopItems,
  gtk3,
  libglvnd,
  libxxf86vm,
  libxrandr,
  libxi,
  libxinerama,
  libxcursor,
  libx11,
  libxext,
  lpac,
}:

buildGoModule rec {
  pname = "easylpac";
  version = "0.8.0.2";

  src = fetchFromGitHub {
    owner = "creamlike1024";
    repo = "EasyLPAC";
    tag = version;
    hash = "sha256-GxcaMyEaPIGf+/wzmmycmFssTkP5Praj4GCYbxbJU28=";
  };

  vendorHash = "sha256-52I8hlnoHPhygwr0dxDP50X2A7Gsh0v/0SGQFH3FG/8=";

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libglvnd
    libxxf86vm
    libx11
    libxrandr
    libxinerama
    libxcursor
    libxi
    libxext
  ];

  postInstall = ''
    install -Dm644 assets/icon64.png "$out/share/icons/hicolor/64x64/apps/EasyLPAC.png"
    install -Dm644 assets/icon128.png "$out/share/icons/hicolor/128x128/apps/EasyLPAC.png"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ lpac ]}
    )
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "EasyLPAC";
      exec = "EasyLPAC";
      icon = "EasyLPAC";
      desktopName = "EasyLPAC";
      comment = "GUI frontend for lpac, a C-based eUICC LPA";
      categories = [ "Utility" ];
    })
  ];

  __structuredAttrs = true;

  meta = {
    description = "GUI frontend for lpac, a C-based eUICC LPA";
    homepage = "https://github.com/creamlike1024/EasyLPAC";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stargate01 ];
    mainProgram = "EasyLPAC";
    platforms = lib.platforms.linux;
  };
}
