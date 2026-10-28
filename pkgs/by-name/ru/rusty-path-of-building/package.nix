{
  lib,
  rustPlatform,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  pkg-config,
  icoutils,
  luajit,
  openssl,
  libxkbcommon,
  vulkan-loader,
  wayland,
  libxi,
  libxcursor,
  libx11,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rusty-path-of-building";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "meehl";
    repo = "rusty-path-of-building";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6ZXJZW/ct9cRhHNr8lBPYnDX49qOGOdjU9TO9DlgiOw=";
  };

  cargoHash = "sha256-jHCLhrk6bORFQsoKV6MbhK51K69atOBoe97emrSofqI=";

  nativeBuildInputs = [
    pkg-config
    icoutils
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    luajit
    openssl
    wayland
  ];

  postInstall = ''
    install -Dm444 assets/icon.png $out/share/icons/hicolor/256x256/apps/path-of-building.png
  '';

  postFixup = ''
    patchelf $out/bin/rusty-path-of-building \
      --add-rpath ${
        lib.makeLibraryPath [
          libxkbcommon
          vulkan-loader
          wayland
          libx11
          libxcursor
          libxi
        ]
      }

    wrapProgram $out/bin/rusty-path-of-building \
      --set LUA_PATH "$LUA_PATH" \
      --set LUA_CPATH "$LUA_CPATH"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "rusty-path-of-building-1";
      desktopName = "Path of Building";
      comment = "Offline build planner for Path of Exile";
      exec = "rusty-path-of-building poe1 %u";
      terminal = false;
      type = "Application";
      icon = "path-of-building";
      categories = [ "Game" ];
      keywords = [
        "poe"
        "pob"
        "pobc"
        "path"
        "exile"
      ];
      mimeTypes = [ "x-scheme-handler/pob" ];
    })
    (makeDesktopItem {
      name = "rusty-path-of-building-2";
      desktopName = "Path of Building 2";
      comment = "Offline build planner for Path of Exile 2";
      exec = "rusty-path-of-building poe2 %u";
      terminal = false;
      type = "Application";
      icon = "path-of-building";
      categories = [ "Game" ];
      keywords = [
        "poe"
        "pob"
        "pobc"
        "path"
        "exile"
      ];
      mimeTypes = [ "x-scheme-handler/pob2" ];
    })
  ];

  meta = {
    description = "A cross-platform runtime for Path of Building and Path of Building 2.";
    homepage = "https://github.com/meehl/rusty-path-of-building";
    changelog = "https://github.com/meehl/rusty-path-of-building/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      k900
      cholli
    ];
    mainProgram = "rusty-path-of-building";
  };
})
