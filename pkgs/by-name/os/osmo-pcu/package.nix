{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libosmocore,
}:

stdenv.mkDerivation rec {
  pname = "osmo-pcu";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-pcu";
    rev = version;
    hash = "sha256-ibcmR046Go6IAlMClUZFoTc/gpy/q5Mp0hJIx/4tKqo=";
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
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Osmocom Packet control Unit (PCU): Network-side GPRS (RLC/MAC); BTS- or BSC-colocated";
    mainProgram = "osmo-pcu";
    homepage = "https://osmocom.org/projects/osmopcu";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.markuskowa ];
    platforms = lib.platforms.linux;
  };
}
