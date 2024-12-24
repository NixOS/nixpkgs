{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libosmocore,
  libosmoabis,
  libosmo-netif,
}:

stdenv.mkDerivation rec {
  pname = "osmo-bts";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-bts";
    rev = version;
    hash = "sha256-l0iCoiMeBGlJpMvnHUrUfGL3sQCT69D739wiYbnSFeI=";
  };

  postPatch = ''
    echo "${version}" > .tarball-version
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libosmocore
    libosmoabis
    libosmo-netif
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Osmocom GSM Base Transceiver Station (BTS)";
    homepage = "https://osmocom.org/projects/osmobts";
    license = lib.licenses.agpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
