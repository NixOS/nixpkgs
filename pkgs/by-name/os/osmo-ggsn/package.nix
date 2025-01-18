{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libosmocore,
}:

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

  meta = with lib; {
    description = "Osmocom Gateway GPRS Support Node (GGSN), successor of OpenGGSN";
    homepage = "https://osmocom.org/projects/openggsn";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
    mainProgram = "osmo-ggsn";
  };
}
