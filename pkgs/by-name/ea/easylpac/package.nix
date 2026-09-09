{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  makeDesktopItem,
  copyDesktopItems,
  desktopToDarwinBundle,
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
  version = "0.8.1.1";

  src = fetchFromGitHub {
    owner = "creamlike1024";
    repo = "EasyLPAC";
    tag = version;
    hash = "sha256-xMXi+AJjbKX7RlcUAutbL/Gfg+DoltSldQza7YMgUWU=";
  };

  vendorHash = "sha256-9tDXkrTX2usGfmmX5Gt8izQEk6/A3ckwQJfHZ5bSjV4=";

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
    wrapGAppsHook3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Generate Applications/EasyLPAC.app from the desktop item, so the
    # app shows up in Spotlight/Launchpad instead of being CLI-only.
    desktopToDarwinBundle
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
    platforms = lib.platforms.unix;
  };
}
