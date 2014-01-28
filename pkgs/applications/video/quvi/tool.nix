{stdenv, fetchurl, pkgconfig, lua5, curl, quvi_scripts, libquvi, lua5_sockets, glib, makeWrapper}:

stdenv.mkDerivation rec {
  name = "quvi-${version}";
  version="0.9.4";

  src = fetchurl {
    url = "mirror://sourceforge/quvi/quvi-${version}.tar.xz";
    sha256 = "047rrwnnp72624z2px5nzn5wxi5fyckkddh2pj8j5xs6kdim429m";
  };

  buildInputs = [ pkgconfig lua5 curl quvi_scripts libquvi glib makeWrapper ];
  postInstall = ''
      wrapProgram $out/bin/quvi --set LUA_PATH "${lua5_sockets}/share/lua/${lua5.luaversion}/?.lua"
  '';

  meta = {
    description = "Web video downloader";
    homepage = http://quvi.sf.net;
    license = "LGPLv2.1+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.mornfall ];
  };
}

