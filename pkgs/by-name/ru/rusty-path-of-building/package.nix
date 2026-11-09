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
  aws-lc,
  zstd,
  libxi,
  libxcursor,
  libx11,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rusty-path-of-building";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "meehl";
    repo = "rusty-path-of-building";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hi3hNoD21d60wjY8H/T9bvBLNhpq2+r0q4EzVRhicpA=";
  };

  cargoHash = "sha256-RbfiGQPQdgdZuoFxPDfbmCjPYBfaNqfZThyg6y0UnQM=";

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
    aws-lc
    zstd
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
