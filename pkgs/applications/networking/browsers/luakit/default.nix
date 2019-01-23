{stdenv, fetchFromGitHub, pkgconfig, wrapGAppsHook, makeWrapper
,help2man, lua5, luafilesystem, luajit, sqlite
,webkitgtk, gtk3, gst_all_1, glib-networking}:

let
  lualibs = [luafilesystem];
  getPath       = lib : type : "${lib}/lib/lua/${lua5.luaversion}/?.${type};${lib}/share/lua/${lua5.luaversion}/?.${type}";
  getLuaPath    = lib : getPath lib "lua";
  getLuaCPath   = lib : getPath lib "so";
  luaPath       = stdenv.lib.concatStringsSep ";" (map getLuaPath lualibs);
  luaCPath      = stdenv.lib.concatStringsSep ";" (map getLuaCPath lualibs);

in stdenv.mkDerivation rec {

  name = "luakit-${version}";
  version = "2017.08.10";
  src = fetchFromGitHub {
    owner = "luakit";
    repo = "luakit";
    rev = "${version}";
    sha256 = "09z88b50vf2y64vj79cymknyzk3py6azv4r50jng4cw9jx2ray7r";
  };

  nativeBuildInputs = [pkgconfig help2man wrapGAppsHook makeWrapper];

  buildInputs = [webkitgtk lua5 luafilesystem luajit sqlite gtk3
    gst_all_1.gstreamer gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good gst_all_1.gst-plugins-bad gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    glib-networking # TLS support
  ];

  postPatch =
    #Kind of ugly seds here. There must be a better solution.
  ''
    patchShebangs ./build-utils
    sed -i "2 s|require \"lib.lousy.util\"|dofile(\"./lib/lousy/util.lua\")|" ./build-utils/docgen/gen.lua;
    sed -i "3 s|require \"lib.markdown\"|dofile(\"./lib/markdown.lua\")|" ./build-utils/docgen/gen.lua;
    sed -i "1,2 s|require(\"lib.lousy.util\")|dofile(\"./lib/lousy/util.lua\")|" ./build-utils/find_files.lua;
  '';

  buildPhase = ''
    make DEVELOPMENT_PATHS=0 USE_LUAJIT=1 INSTALLDIR=$out PREFIX=$out USE_GTK3=1
  '';

  installPhase = let
    luaKitPath = "$out/share/luakit/lib/?/init.lua;$out/share/luakit/lib/?.lua";
  in ''
    make DEVELOPMENT_PATHS=0 INSTALLDIR=$out PREFIX=$out XDGPREFIX=$out/etc/xdg USE_GTK3=1 install
    wrapProgram $out/bin/luakit                                         \
      --prefix XDG_CONFIG_DIRS : "$out/etc/xdg"                         \
      --set LUA_PATH '${luaKitPath};${luaPath};'                      \
      --set LUA_CPATH '${luaCPath};'
  '';

  meta = with stdenv.lib; {
    description = "Fast, small, webkit based browser framework extensible in Lua";
    homepage    = "http://luakit.org";
    license     = licenses.gpl3;
    platforms   = platforms.linux; # Only tested linux
  };
}
