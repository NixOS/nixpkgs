{ stdenv, fetchurl, kdelibs, kdepimlibs, boost }:

stdenv.mkDerivation rec {
  name = "zanshin-0.2.2";

  src = fetchurl {
    url = "http://files.kde.org/zanshin/zanshin-0.2.0.tar.bz2";
    sha256 = "0kskk8rj4bwx5zywxw0h2lgl7byw9dxzdcafb6xp5cvdkjkg9j87";
  };

  buildInputs = [ kdelibs kdepimlibs boost ];

  meta = {
    description = "GTD for KDE";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    inherit (kdelibs.meta) platforms;
  };
}
