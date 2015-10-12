{ stdenv, fetchurl, automoc4, cmake, gettext, perl, pkgconfig, shared_mime_info
, libxslt, kdelibs, kdepimlibs, grantlee, qjson, qca2, libofx, sqlite, boost }:

stdenv.mkDerivation rec {
  name = "skrooge-1.10.0";

  src = fetchurl {
    url = "http://download.kde.org/stable/skrooge/${name}.tar.bz2";
    sha256 = "0rsw2xdgws5bvnf3h4hg16liahigcxgaxls7f8hzr9wipxx5xqda";
  };

  buildInputs = [ libxslt kdelibs kdepimlibs grantlee qjson qca2 libofx sqlite boost ];

  nativeBuildInputs = [ automoc4 cmake gettext perl pkgconfig shared_mime_info ];

  meta = {
    inherit (kdelibs.meta) platforms;
    description = "A personal finance manager for KDE";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    license = stdenv.lib.licenses.gpl3;
  };
}
