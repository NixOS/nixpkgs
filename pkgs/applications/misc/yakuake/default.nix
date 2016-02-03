{ stdenv, fetchurl, automoc4, cmake, gettext, perl, pkgconfig
, kdelibs, konsole }:

let
  pname = "yakuake";
  version = "2.9.9";
in
stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${pname}-${version}.tar.xz";
    sha256 = "0e0e4994c568f8091c9424e4aab35645436a9ff341c00b1cd1eab0ada0bf61ce";
  };

  buildInputs = [ kdelibs ];

  nativeBuildInputs = [ automoc4 cmake gettext perl pkgconfig ];

  propagatedUserEnvPkgs = [ konsole ];

  meta = {
    homepage = http://yakuake.kde.org;
    description = "Quad-style terminal emulator for KDE";
    inherit (kdelibs.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
