{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libosmocore,
  libosmoabis,
  libosmo-netif,
  libosmo-sigtran,
  osmo-mgw,
}:

stdenv.mkDerivation rec {
  pname = "osmo-bsc";
  version = "1.12.4";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-bsc";
    rev = version;
    hash = "sha256-46riudURcWwm9HuC8t0A2WWnkmSL9yvZFKRgVMxNzrc=";
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
    libosmo-sigtran
    osmo-mgw
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "GSM Base Station Controller";
    homepage = "https://projects.osmocom.org/projects/osmobsc";
    license = licenses.agpl3Plus;
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
    mainProgram = "osmo-bsc";
  };
}
