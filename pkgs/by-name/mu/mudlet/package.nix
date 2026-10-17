{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  git,
  pkg-config,
  which,
  assimp,
  boost,
  discord-rpc,
  hunspell,
  libGLU,
  libsecret,
  libzip,
  lua5_1,
  pipewire,
  pugixml,
  qt6Packages,
  yajl,
  withDiscordRpc ? false,
}:

let
  luaEnv = lua5_1.withPackages (
    ps: with ps; [
      lpeg
      lrexlib-pcre2
      lua-yajl
      luafilesystem
      luasql-sqlite3
      luautf8
      luazip
    ]
  );
  libPathVar = if stdenv.hostPlatform.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mudlet";
  version = "4.20.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Mudlet";
    repo = "Mudlet";
    rev = "Mudlet-${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-o3f2ChQ7COql+WEe2diATx7wIR0fOlxkXcGWlL1AYkE=";
  };

  nativeBuildInputs = [
    cmake
    git
    luaEnv
    pkg-config
    qt6Packages.qttools
    qt6Packages.wrapQtAppsHook
    which
  ];

  buildInputs = [
    assimp
    boost
    hunspell
    libGLU
    libsecret
    libzip
    luaEnv
    pugixml
    qt6Packages.qtbase
    qt6Packages.qt5compat
    qt6Packages.qtkeychain
    qt6Packages.qtmultimedia
    yajl
  ]
  ++ lib.optional withDiscordRpc discord-rpc;

  cmakeFlags = [
    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    (lib.cmakeBool "CMAKE_SKIP_BUILD_RPATH" true)
    (lib.cmakeBool "USE_FONTS" false)
    (lib.cmakeBool "USE_OWN_QTKEYCHAIN" false)
    (lib.cmakeBool "USE_UPDATER" false)
  ];

  installPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    cp -r src/mudlet.app/ $out/Applications/mudlet.app
  '';

  preFixup = ''
    qtWrapperArgs+=(--set LUA_CPATH "${luaEnv}/lib/lua/${lua5_1.luaversion}/?.so")
    qtWrapperArgs+=(--prefix LUA_PATH : "$NIX_LUA_PATH")
    qtWrapperArgs+=(--prefix ${libPathVar} : "${
      lib.makeLibraryPath (
        lib.optional stdenv.hostPlatform.isLinux pipewire ++ lib.optional withDiscordRpc discord-rpc
      )
    }")
    qtWrapperArgs+=(--chdir "$out")
  '';

  meta = {
    description = "Crossplatform mud client";
    homepage = "https://www.mudlet.org/";
    maintainers = with lib.maintainers; [
      wyvie
      pstn
      felixalbrigtsen
    ];
    platforms = with lib.platforms; linux ++ darwin;
    license = lib.licenses.gpl2Plus;
    mainProgram = "mudlet";
  };
})
