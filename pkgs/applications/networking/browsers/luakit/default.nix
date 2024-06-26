{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  help2man,
  glib-networking,
  gst_all_1,
  gtk3,
  luafilesystem,
  luajit,
  sqlite,
  webkitgtk,
}:

stdenv.mkDerivation rec {
  pname = "luakit";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "luakit";
    repo = pname;
    rev = version;
    hash = "sha256-DtoixcLq+ddbacTAo+Qq6q4k1i6thirACw1zqUeOxXo=";
  };

  nativeBuildInputs = [
    pkg-config
    help2man
    wrapGAppsHook3
  ];
  buildInputs =
    [
      gtk3
      glib-networking # TLS support
      luafilesystem
      luajit
      sqlite
      webkitgtk
    ]
    ++ (with gst_all_1; [
      gstreamer
      gst-plugins-base
      gst-plugins-good
      gst-plugins-bad
      gst-plugins-ugly
      gst-libav
    ]);

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

  meta = with lib; {
    homepage = "https://luakit.github.io/";
    description = "Fast, small, webkit-based browser framework extensible in Lua";
    mainProgram = "luakit";
    longDescription = ''
      Luakit is a highly configurable browser framework based on the WebKit web
      content engine and the GTK+ toolkit. It is very fast, extensible with Lua,
      and licensed under the GNU GPLv3 license. It is primarily targeted at
      power users, developers and anyone who wants to have fine-grained control
      over their web browser’s behaviour and interface.
    '';
    license = licenses.gpl3Only;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
