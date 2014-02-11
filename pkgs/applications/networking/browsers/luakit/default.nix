{ stdenv, fetchurl, lua5, webkit_gtk2, libunique, sqlite, pkgconfig, gtk, libsoup, git, lua5_filesystem, makeWrapper, glib_networking, gsettings_desktop_schemas, help2man }:

stdenv.mkDerivation rec {
  name = "luakit-${version}"; 
  version = "2012.09.13-r1";
  src = fetchurl {
    url = "https://github.com/mason-larobina/luakit/tarball/${version}";
    name = "luakit-${version}.tar.gz";
    sha256 = "0ck1yw08nx6wklzjjlh5ljxza6zw0mjvlllbk5v2j0qzl7ym12b8";
  };

  buildInputs = [ lua5 webkit_gtk2 libunique sqlite pkgconfig gtk libsoup git makeWrapper help2man ];
  postPatch = '' 
    sed -i -e "s/DESTDIR/INSTALLDIR/" ./Makefile
    sed -i -e "s|/etc/xdg/luakit/|$out/etc/xdg/luakit/|" lib/lousy/util.lua
    patchShebangs ./build-utils
  '';
  buildPhase = '' 
    make DEVELOPMENT_PATHS=0 PREFIX=$out 
  '';
  installPhase = '' 
    make DEVELOPMENT_PATHS=0 PREFIX=$out install 
    wrapProgram "$out/bin/luakit"                                                       \
      --prefix GIO_EXTRA_MODULES : "${glib_networking}/lib/gio/modules"                 \
      --prefix XDG_DATA_DIRS : "${gsettings_desktop_schemas}/share"                     \
      --prefix XDG_DATA_DIRS : "$out/usr/share/"                                        \
      --prefix XDG_DATA_DIRS : "$out/share/"                                            \
      --prefix XDG_CONFIG_DIRS : "$out/etc/xdg"                                         \
      --prefix LUA_PATH    ";" "$out/share/luakit/lib/?/init.lua"                       \
      --prefix LUA_PATH    ";" "$out/share/luakit/lib/?.lua"                            \
      --prefix LUA_CPATH   ";" "${lua5_filesystem}/lib/lua/${lua5.luaversion}/?.so"     \
      --prefix LUA_CPATH   ";" "${lua5}/lib/lua/${lua5.luaversion}/?.so"
  '';

  meta = {
    homepage = "http://mason-larobina.github.io/luakit/";
    description = "Fast, small, webkit based browser framework extensible by Lua.";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.bennofs ];
  };
}