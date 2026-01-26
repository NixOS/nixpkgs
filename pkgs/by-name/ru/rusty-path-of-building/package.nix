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
  libxi,
  libxcursor,
  libx11,
}:
rustPlatform.buildRustPackage rec {
  pname = "rusty-path-of-building";
  version = "0.2.10";

  src = fetchFromGitHub {
    owner = "meehl";
    repo = "rusty-path-of-building";
    rev = "v${version}";
    hash = "sha256-odiiYWoBfcnPNfXsxj0gt/ra6Z3zeBQdWRjF7BazffY=";
  };

  cargoHash = "sha256-OX4L8EmgMJVT6sFZRdhPl36ZUcXq2JEFpb/PJml2YE8=";

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
