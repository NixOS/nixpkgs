{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
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
  libpq ? null,
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
    (replaceVars ./gammu-config-dialog.patch {
      dialog = "${dialog}/bin/dialog";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    # Fix build with CMake 4
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.10")
  ];

  strictDeps = true;

  buildInputs = [
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
  ++ lib.optionals postgresSupport [ libpq ];

  meta = with lib; {
    homepage = "https://wammu.eu/gammu/";
    description = "Command line utility and library to control mobile phones";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.coroa ];
  };
}
