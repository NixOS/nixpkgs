{ stdenv , fetchurl , git , glib_networking , gsettings_desktop_schemas , gtk,
help2man , libunique , lua5 , luafilesystem , luajit , luasqlite3, makeWrapper,
pkgconfig , sqlite , webkit }:

let
  lualibs       = [ luafilesystem luasqlite3 ];
  getPath       = lib : type : "${lib}/lib/lua/${lua5.luaversion}/?.${type};${lib}/share/lua/${lua5.luaversion}/?.${type}";
  getLuaPath    = lib : getPath lib "lua";
  getLuaCPath   = lib : getPath lib "so";
  luaPath       = stdenv.lib.concatStringsSep ";" (map getLuaPath lualibs);
  luaCPath      = stdenv.lib.concatStringsSep ";" (map getLuaCPath lualibs);
in
stdenv.mkDerivation {

  name = "luakit-2012.09.13";

  meta = with stdenv.lib; {
    description = "Fast, small, webkit based browser framework extensible in Lua";
    homepage    = "http://luakit.org";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms   = platforms.linux; # I only tested linux
  };

  src = fetchurl {
    url = "https://github.com/mason-larobina/luakit/archive/2012.09.13-r1.tar.gz";
    sha256 = "067g3bp5w20jypc8rx54dpbn3ysbgxzchgpq7sld5yh2z36s1l52";
  };

  buildInputs = [ git gsettings_desktop_schemas gtk help2man libunique lua5
    luafilesystem luajit luasqlite3 makeWrapper pkgconfig sqlite webkit ];

  postPatch = ''
    sed -i -e "s/DESTDIR/INSTALLDIR/" ./Makefile
    sed -i -e "s|/etc/xdg/luakit/|$out/etc/xdg/luakit/|" lib/lousy/util.lua
    patchShebangs ./build-utils
  '';

  buildPhase = ''
    make DEVELOPMENT_PATHS=0 USE_LUAJIT=1 INSTALLDIR=$out DESTDIR=$out PREFIX=$out USE_GTK3=1
  '';

  installPhase = let
    luaKitPath = "$out/share/luakit/lib/?/init.lua;$out/share/luakit/lib/?.lua";
  in ''
    make DEVELOPMENT_PATHS=0 INSTALLDIR=$out DESTDIR=$out PREFIX=$out USE_GTK3=1 install
    wrapProgram $out/bin/luakit                                         \
      --prefix GIO_EXTRA_MODULES : "${glib_networking.out}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : "${gsettings_desktop_schemas}/share:$out/usr/share/:$out/share/:$GSETTINGS_SCHEMAS_PATH"     \
      --prefix XDG_CONFIG_DIRS : "$out/etc/xdg"                         \
      --set LUA_PATH '${luaKitPath};${luaPath};'                      \
      --set LUA_CPATH '${luaCPath};'
  '';

}
