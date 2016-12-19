{stdenv, fetchurl, pkgconfig, lua5, curl, quvi_scripts, libquvi, lua5_sockets, glib, makeWrapper}:

stdenv.mkDerivation rec {
  name = "quvi-${version}";
  version="0.9.5";

  src = fetchurl {
    url = "mirror://sourceforge/quvi/quvi-${version}.tar.xz";
    sha256 = "1h52s265rp3af16dvq1xlscp2926jqap2l4ah94vrfchv6m1hffb";
  };

  buildInputs = [ pkgconfig lua5 curl quvi_scripts libquvi glib makeWrapper ];
  postInstall = ''
      wrapProgram $out/bin/quvi --set LUA_PATH "${lua5_sockets}/share/lua/${lua5.luaversion}/?.lua"
  '';

  meta = {
    description = "Web video downloader";
    homepage = http://quvi.sf.net;
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.mornfall ];
  };
}
