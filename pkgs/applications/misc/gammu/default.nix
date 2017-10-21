{ stdenv, fetchFromGitHub, python, pkgconfig, cmake, bluez, libusb1, curl
, libiconv, gettext, sqlite
, dbiSupport ? false, libdbi ? null, libdbiDrivers ? null
, postgresSupport ? false, postgresql ? null
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "gammu-${version}";
  version = "1.38.2";

  src = fetchFromGitHub {
    owner = "gammu";
    repo = "gammu";
    rev = version;
    sha256 = "1rk3p3sjyy6n6mlqs4qgyxna4swrh1zm7b77npxv8j341wxj3khv";
  };

  patches = [ ./bashcomp-dir.patch ./systemd.patch ];

  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [ python bluez libusb1 curl gettext sqlite libiconv ]
  ++ optionals dbiSupport [ libdbi libdbiDrivers ]
  ++ optionals postgresSupport [ postgresql ];

  enableParallelBuilding = true;

  meta = {
    homepage = https://wammu.eu/gammu/;
    description = "Command line utility and library to control mobile phones";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.coroa ];
  };
}
