{
  lib,
  rustPlatform,
  fetchurl,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  pkg-config,
  icoutils,
  luajit,
  zlib,
  libxkbcommon,
  vulkan-loader,
  wayland,
}:

let
  icon = fetchurl {
    url = "https://raw.githubusercontent.com/PathOfBuildingCommunity/PathOfBuilding-Launcher/9ee18657fa6597c42811152604da4e6b73fac342/PathOfBuilding.ico";
    hash = "sha256-9EW4ld+xg7GLfd4dEY/xUCBMnKb3uu7LBq2Of3Gq1Y8=";
  };
in
rustPlatform.buildRustPackage rec {
  pname = "rusty-path-of-building";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "meehl";
    repo = "rusty-path-of-building";
    rev = "v${version}";
    hash = "sha256-J/tTifOcbY1mfcNbQFN4Vdyl78O7vTVbfew3fcnVyTA=";
  };

  cargoHash = "sha256-Oekl6SDIvgFIzPnve7nuib3fEjPGC46F/TNULmgOpew=";

  nativeBuildInputs = [
    pkg-config
    icoutils
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    luajit
    luajit.pkgs.lua-curl
    luajit.pkgs.luautf8
    luajit.pkgs.luasocket

    # this is weird and vendored and should probably stay that way
    (luajit.pkgs.buildLuaPackage {
      pname = "lzip";
      inherit version;
      src = "${src}/lua/libs/lzip";

      nativeBuildInputs = [ pkg-config ];
      buildInputs = [ zlib ];
      installFlags = [ "LUA_CMOD=$(out)/lib/lua/${luajit.luaversion}" ];
    })

    wayland
  ];

  postInstall = ''
    icotool -x ${icon}

    for size in 16 32 48 256; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      install -Dm 644 *PathOfBuilding*"$size"x"$size"*.png \
        $out/share/icons/hicolor/"$size"x"$size"/apps/pathofbuilding.png
    done
  '';

  postFixup = ''
    patchelf $out/bin/rusty-path-of-building \
      --add-rpath ${
        lib.makeLibraryPath [
          libxkbcommon
          vulkan-loader
          wayland
        ]
      }

    wrapProgram $out/bin/rusty-path-of-building \
      --set LUA_PATH "$LUA_PATH" \
      --set LUA_CPATH "$LUA_CPATH"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "rusty-path-of-building";
      desktopName = "Path of Building";
      comment = "Offline build planner for Path of Exile";
      exec = "rusty-path-of-building poe1";
      terminal = false;
      type = "Application";
      icon = "pathofbuilding";
      categories = [ "Game" ];
      keywords = [
        "poe"
        "pob"
        "pobc"
        "path"
        "exile"
      ];
    })
    (makeDesktopItem {
      name = "rusty-path-of-building-2";
      desktopName = "Path of Building 2";
      comment = "Offline build planner for Path of Exile 2";
      exec = "rusty-path-of-building poe2";
      terminal = false;
      type = "Application";
      icon = "pathofbuilding";
      categories = [ "Game" ];
      keywords = [
        "poe"
        "pob"
        "pobc"
        "path"
        "exile"
      ];
    })
  ];

  meta = {
    description = "A cross-platform runtime for Path of Building and Path of Building 2.";
    homepage = "https://github.com/meehl/rusty-path-of-building";
    changelog = "https://github.com/meehl/rusty-path-of-building/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ k900 ];
    mainProgram = "rusty-path-of-building";
  };
}
