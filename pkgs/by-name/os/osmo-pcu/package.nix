{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libosmocore,
}:

let
  inherit (stdenv.hostPlatform) isLinux;
in

stdenv.mkDerivation rec {
  pname = "osmo-pcu";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-pcu";
    rev = version;
    hash = "sha256-deFUitxcg0G3dXY13BqgqToJrB2FBEU/YE2yKxyaMvk=";
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
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
