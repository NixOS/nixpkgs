{
  lib,
  stdenv,
  fetchFromGitHub,
  substituteAll,
  pkg-config,
  cmake,
  bluez,
  libusb1,
  curl,
  libiconv,
  gettext,
  sqlite,
  bash,
  dialog,
  dbiSupport ? false,
  libdbi ? null,
  libdbiDrivers ? null,
  postgresSupport ? false,
  postgresql ? null,
}:

stdenv.mkDerivation rec {
  pname = "gammu";
  version = "1.42.0";

  src = fetchFromGitHub {
    owner = "gammu";
    repo = "gammu";
    rev = version;
    sha256 = "sha256-aeaGHVxOMiXRU6RHws+oAnzdO9RY1jw/X/xuGfSt76I=";
  };

  patches = [
    ./bashcomp-dir.patch
    ./systemd.patch
    (substituteAll {
      src = ./gammu-config-dialog.patch;
      dialog = "${dialog}/bin/dialog";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  strictDeps = true;

  buildInputs =
    [
      bash
      bluez
      libusb1
      curl
      gettext
      sqlite
      libiconv
    ]
    ++ lib.optionals dbiSupport [
      libdbi
      libdbiDrivers
    ]
    ++ lib.optionals postgresSupport [ postgresql ];

  meta = with lib; {
    homepage = "https://wammu.eu/gammu/";
    description = "Command line utility and library to control mobile phones";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.coroa ];
  };
}
