{ stdenv, fetchurl, kdelibs, gettext }:

let
  pname = "yakuake";
  version = "2.9.8";
in
stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${pname}-${version}.tar.bz2";
    sha256 = "0a9x3nmala8nl4xl3h7rcd76f5j7b7r74jc5cfbayc6jgkjdynd3";
  };

  buildInputs = [ kdelibs ];

  buildNativeInputs = [ gettext ];

  meta = {
    homepage = http://yakuake.kde.org;
    description = "Quad-style terminal emulator for KDE";
    inherit (kdelibs.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
