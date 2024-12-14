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
  pname = "osmo-ggsn";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-ggsn";
    rev = version;
    hash = "sha256-sSAIJI7iGNmyXr3t+PXPi1SSzS2Nd3Aze2nvzu/MNI4=";
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
    description = "Osmocom Gateway GPRS Support Node (GGSN), successor of OpenGGSN";
    homepage = "https://osmocom.org/projects/openggsn";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "osmo-ggsn";
  };
}
