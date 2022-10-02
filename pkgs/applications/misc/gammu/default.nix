{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, bluez, libusb1, curl
, libiconv, gettext, sqlite
, dbiSupport ? false, libdbi ? null, libdbiDrivers ? null
, postgresSupport ? false, postgresql ? null
}:

with lib;

stdenv.mkDerivation rec {
  pname = "gammu";
  version = "1.42.0";

  src = fetchFromGitHub {
    owner = "gammu";
    repo = "gammu";
    rev = version;
    sha256 = "sha256-aeaGHVxOMiXRU6RHws+oAnzdO9RY1jw/X/xuGfSt76I=";
  };

  patches = [ ./bashcomp-dir.patch ./systemd.patch ];

  nativeBuildInputs = [ pkg-config cmake ];

  strictDeps = true;

  buildInputs = [ bluez libusb1 curl gettext sqlite libiconv ]
  ++ optionals dbiSupport [ libdbi libdbiDrivers ]
  ++ optionals postgresSupport [ postgresql ];

  meta = {
    homepage = "https://wammu.eu/gammu/";
    description = "Command line utility and library to control mobile phones";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.coroa ];
  };
}
