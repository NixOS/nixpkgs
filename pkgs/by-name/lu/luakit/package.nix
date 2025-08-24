{
  lib,
  fetchFromGitHub,
  glib-networking,
  gst_all_1,
  gtk3,
  help2man,
  luajit,
  luajitPackages,
  pkg-config,
  sqlite,
  stdenv,
  webkitgtk_4_1,
  wrapGAppsHook3,
}:
let
  inherit (luajitPackages) luafilesystem;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "luakit";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "luakit";
    repo = "luakit";
    rev = finalAttrs.version;
    hash = "sha256-6OPcGwWQyP+xWVKGjwEfE8Xnf1gcwwbO+FbvA1x0c8M=";
  };

  nativeBuildInputs = [
    luajit
    pkg-config
    help2man
    wrapGAppsHook3
  ];

  buildInputs = [
    glib-networking # TLS support
    gtk3
    luafilesystem
    sqlite
    webkitgtk_4_1
  ]
  ++ (with gst_all_1; [
    gst-libav
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gstreamer
  ]);

  strictDeps = true;

  # build-utils/docgen/gen.lua:2: module 'lib.lousy.util' not found
  # TODO: why is not this the default? The test runner adds
  # ';./lib/?.lua;./lib/?/init.lua' to package.path, but the build-utils
  # scripts don't add an equivalent
  preBuild = ''
    export LUA_PATH="$LUA_PATH;./?.lua;./?/init.lua"
  '';

  makeFlags = [
    "DEVELOPMENT_PATHS=0"
    "USE_LUAJIT=1"
    "LUA_BIN_NAME=luajit"
    "INSTALLDIR=${placeholder "out"}"
    "PREFIX=${placeholder "out"}"
    "USE_GTK3=1"
    "XDGPREFIX=${placeholder "out"}/etc/xdg"
  ];

  preFixup =
    let
      luaKitPath = "$out/share/luakit/lib/?/init.lua;$out/share/luakit/lib/?.lua";
    in
    ''
      gappsWrapperArgs+=(
        --prefix XDG_CONFIG_DIRS : "$out/etc/xdg"
        --prefix LUA_PATH ';' "${luaKitPath};$LUA_PATH"
        --prefix LUA_CPATH ';' "$LUA_CPATH"
      )
    '';

  meta = {
    homepage = "https://luakit.github.io/";
    description = "Fast, small, webkit-based browser framework extensible in Lua";
    longDescription = ''
      Luakit is a highly configurable browser framework based on the WebKit web
      content engine and the GTK+ toolkit. It is very fast, extensible with Lua,
      and licensed under the GNU GPLv3 license. It is primarily targeted at
      power users, developers and anyone who wants to have fine-grained control
      over their web browser’s behaviour and interface.
    '';
    license = lib.licenses.gpl3Only;
    mainProgram = "luakit";
    maintainers = with lib.maintainers; [
      griffi-gh
    ];
    platforms = lib.platforms.unix;
  };
})
