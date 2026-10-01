{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libosmocore,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "osmo-pcu";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-pcu";
    rev = finalAttrs.version;
    hash = "sha256-0LbGw+whExyuYeBltWGN7gLRBbos6lMbirOTv+mf/5A=";
  };

  postPatch = ''
    echo "${finalAttrs.version}" > .tarball-version
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
})
