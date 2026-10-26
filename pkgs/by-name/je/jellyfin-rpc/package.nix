{
  lib,
  stdenv,
  fetchurl,
  unzip,
  autoPatchelfHook,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  xkeyboard_config,
  libGL,
  libxkbcommon,
  fontconfig,
  freetype,
  wayland,
  libx11,
  libxcursor,
  libxrandr,
  libxi,
  libxext,
  libxrender,
  libxcb,
  zlib,
  glibc,
}:

let
  pname = "jellyfin-rpc";
  version = "1.12.0";

  selectSystem =
    {
      x86_64-linux = {
        target = "linux-x86_64";
        hash = "sha256-fuPBnhl3rHVk03dKVaEDIaTR4fVnrN68vywye00flU0=";
      };
      x86_64-darwin = {
        target = "macos-amd64";
        hash = "sha256-PxpKHaX176Vk03dKVaEDIaTR4fVnrN68vywye00flU0=";
      };
      aarch64-darwin = {
        target = "macos-arm64";
        hash = "sha256-URAkRXiV/Ka313WVDurS/T9Pbe3wo2RHvD//C76DTwk=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  appIcon = fetchurl {
    url = "https://raw.githubusercontent.com/kennethsible/jellyfin-rpc/main/images/icon.png";
    hash = "sha256-PPJNNlOfEyOvQMz0+DuNpCJSnwUzXlo1i8aHxUwCN+I=";
  };

  srcZip = fetchurl {
    url = "https://github.com/kennethsible/jellyfin-rpc/releases/download/v${version}/jellyfin-rpc-${version}-${selectSystem.target}.zip";
    hash = selectSystem.hash;
  };

in
stdenv.mkDerivation {
  inherit pname version;

  src = srcZip;
  strictDeps = true;

  nativeBuildInputs = [
    unzip
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib
    glibc
    zlib
    xkeyboard_config
    libGL
    libxkbcommon
    fontconfig
    freetype
    wayland
    libx11
    libxcursor
    libxrandr
    libxi
    libxext
    libxrender
    libxcb
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "jellyfin-rpc";
      exec = "jellyfin-rpc";
      icon = "jellyfin-rpc";
      comment = "Discord Rich Presence client for Jellyfin";
      desktopName = "Jellyfin RPC";
      categories = [
        "Utility"
        "Network"
      ];
    })
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/opt/jellyfin-rpc
    mkdir -p $out/share/icons/hicolor/512x512/apps

    cp -r * $out/opt/jellyfin-rpc/
    cp ${appIcon} $out/share/icons/hicolor/512x512/apps/jellyfin-rpc.png

    EXEPATH=$(find $out/opt/jellyfin-rpc -maxdepth 2 -type f \( -name "*.AppImage" -o -name "jellyfin-rpc" -o -name "jellyfin_rpc" \) | head -n 1)

    if [ -n "$EXEPATH" ]; then
      chmod +x "$EXEPATH"

      makeWrapper "$EXEPATH" $out/bin/jellyfin-rpc \
        --set XKB_CONFIG_ROOT "${xkeyboard_config}/share/X11/xkb" \
        --set FONTCONFIG_FILE "${fontconfig.out}/etc/fonts/fonts.conf" \
        --prefix LD_LIBRARY_PATH : "${
          lib.makeLibraryPath [
            libGL
            libxkbcommon
            fontconfig
            freetype
            wayland
            libx11
            libxcursor
            libxrandr
            libxi
            libxext
            libxrender
            libxcb
          ]
        }"
    else
      echo "Error: Binary not found in release archive!"
      exit 1
    fi

    runHook postInstall
  '';

  meta = with lib; {
    mainProgram = "jellyfin-rpc";
    description = "Discord RPC for Jellyfin that displays what you're watching or listening to";
    homepage = "https://github.com/kennethsible/jellyfin-rpc";
    license = licenses.mit;
    maintainers = with maintainers; [ _2hexed ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
