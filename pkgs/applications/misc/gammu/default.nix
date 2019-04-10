{ stdenv, fetchFromGitHub, python, pkgconfig, cmake, bluez, libusb1, curl
, libiconv, gettext, sqlite
, dbiSupport ? false, libdbi ? null, libdbiDrivers ? null
, postgresSupport ? false, postgresql ? null
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "gammu-${version}";
  version = "1.40.0";

  src = fetchFromGitHub {
    owner = "gammu";
    repo = "gammu";
    rev = version;
    sha256 = "1jjaa9r3x6i8gv3yn1ngg815s6gsxblsw4wb5ddm77kamn2qyvpf";
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
