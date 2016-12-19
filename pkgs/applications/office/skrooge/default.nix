{ stdenv, fetchurl, automoc4, cmake, gettext, perl, pkgconfig, shared_mime_info
, libxslt, kdelibs, kdepimlibs, grantlee, qjson, qca2, libofx, sqlite, boost }:

stdenv.mkDerivation rec {
  name = "skrooge-1.12.5";

  src = fetchurl {
    url = "http://download.kde.org/stable/skrooge/${name}.tar.xz";
    sha256 = "1mnkm0367knh0a65gifr20p42ql9zndw7d6kmbvfshvpfsmghl40";
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
