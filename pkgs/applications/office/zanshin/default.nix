{ stdenv, fetchurl, automoc4, cmake, perl, pkgconfig
, kdelibs4, kdepimlibs, boost, baloo }:

stdenv.mkDerivation rec {
  name = "zanshin-0.3.1";

  src = fetchurl {
    url = "http://files.kde.org/zanshin/${name}.tar.bz2";
    sha256 = "1ck2ncz8i816d6d1gcsdrh6agd2zri24swgz3bhn8vzbk4215yzl";
  };

  nativeBuildInputs = [ automoc4 cmake perl pkgconfig ];

  buildInputs = [ kdelibs4 kdepimlibs boost baloo ];

  meta = {
    description = "GTD for KDE";
    maintainers = [ ];
    inherit (kdelibs4.meta) platforms;
  };
}
