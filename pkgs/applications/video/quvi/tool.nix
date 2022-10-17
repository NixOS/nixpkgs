{lib, stdenv, fetchurl, pkg-config, lua5, curl, quvi_scripts, libquvi, lua5_sockets, glib, makeWrapper}:

stdenv.mkDerivation rec {
  pname = "quvi";
  version="0.9.5";

  src = fetchurl {
    url = "mirror://sourceforge/quvi/quvi-${version}.tar.xz";
    sha256 = "1h52s265rp3af16dvq1xlscp2926jqap2l4ah94vrfchv6m1hffb";
  };

  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [ lua5 curl quvi_scripts libquvi glib ];
  postInstall = ''
      wrapProgram $out/bin/quvi --set LUA_PATH "${lua5_sockets}/share/lua/${lua5.luaversion}/?.lua"
  '';

  meta = {
    description = "Web video downloader";
    homepage = "http://quvi.sf.net";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    broken = true; # missing glibc-2.34 support, no upstream activity
  };
}
