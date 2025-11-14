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
  xorg,
}:
rustPlatform.buildRustPackage rec {
  pname = "rusty-path-of-building";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "meehl";
    repo = "rusty-path-of-building";
    rev = "v${version}";
    hash = "sha256-GJP5kuDHDyKFzlDW3EiMzd2KruYB1L51QgK4NT6B3Cc=";
  };

  cargoHash = "sha256-RfF53qd/crWDgEDveP58FPInlH7vtpprMU3aLf9KO8A=";

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
    install -Dm444 assets/icon.png $out/share/icons/hicolor/256x256/apps/path-of-building.png
  '';

  postFixup = ''
    patchelf $out/bin/rusty-path-of-building \
      --add-rpath ${
        lib.makeLibraryPath [
          libxkbcommon
          vulkan-loader
          wayland
          xorg.libX11
          xorg.libXcursor
          xorg.libXi
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
      exec = "rusty-path-of-building poe1";
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
    })
    (makeDesktopItem {
      name = "rusty-path-of-building-2";
      desktopName = "Path of Building 2";
      comment = "Offline build planner for Path of Exile 2";
      exec = "rusty-path-of-building poe2";
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
