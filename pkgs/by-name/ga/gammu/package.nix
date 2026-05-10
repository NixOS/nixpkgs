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
  libdbi-drivers ? null,
  postgresSupport ? false,
  libpq ? null,
  libgudev,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gammu";
  version = "1.43.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gammu";
    repo = "gammu";
    rev = finalAttrs.version;
    sha256 = "sha256-+mZBELwFUEL4S3IUIIa83TaNIYQxjQE1TvWhXTcIfYc=";
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
    glib
    sqlite
    libiconv
    libgudev
  ]
  ++ lib.optionals dbiSupport [
    libdbi
    libdbi-drivers
  ]
  ++ lib.optionals postgresSupport [ libpq ];

  meta = {
    homepage = "https://wammu.eu/gammu/";
    description = "Command line utility and library to control mobile phones";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
