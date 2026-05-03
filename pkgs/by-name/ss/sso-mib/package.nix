{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libjwt,
  libuuid,
  glib,
  json-glib,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "sso-mib";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "siemens";
    repo = "sso-mib";
    rev = "v${version}";
    hash = "sha256-C5Gaes8mAQMNAY51tJu4U26AyQ3Thy6mpXg4ewgMRP8=";
  };

  outputs = [
    "out"
    "dev"
    "bin"
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
    libjwt
    libuuid
    glib
    json-glib
  ];

  passthru.updateScript = nix-update-script { };

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/siemens/sso-mib";
    description = "C library to interact with a locally running microsoft-identity-broker to get various authentication tokens via DBus.";
    maintainers = [ maintainers.michaeladler ];
    platforms = platforms.all;
    license = [
      licenses.gpl2Only
      licenses.lgpl21Only
    ];
  };
}
