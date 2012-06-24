{ stdenv, fetchurl, kdelibs, kdepimlibs, boost }:

stdenv.mkDerivation rec {
  name = "zanshin-0.2.1";

  src = fetchurl {
    url = "http://files.kde.org/zanshin/${name}.tar.bz2";
    sha256 = "155k72vk7kw0p0x9dhlky6q017kanzcbwvp4dpf1hcbr1dsr55fx";
  };

  buildInputs = [ kdelibs kdepimlibs boost ];

  meta = {
    description = "GTD for KDE";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    inherit (kdelibs.meta) platforms;
  };
}
