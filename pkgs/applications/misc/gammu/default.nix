{ stdenv, fetchurl, python, pkgconfig, cmake, bluez, libusb1, curl
, libiconv, gettext, sqlite
, dbiSupport ? false, libdbi ? null, libdbiDrivers ? null
, postgresSupport ? false, postgresql ? null
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "gammu-${version}";
  version = "1.33.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/gammu/gammu/${version}/gammu-${version}.tar.xz";
    sha256 = "18gplx1v9d70k1q86d5i4n4dfpx367g34pj3zscppx126vwhv112";
  };

  patches = [ ./bashcomp-dir.patch ];

  buildInputs = [ python pkgconfig cmake bluez libusb1 curl gettext sqlite libiconv ]
  ++ optionals dbiSupport [ libdbi libdbiDrivers ]
  ++ optionals postgresSupport [ postgresql ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://wammu.eu/gammu/";
    description = "Command line utility and library to control mobile phones";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.coroa ];
  };
}
