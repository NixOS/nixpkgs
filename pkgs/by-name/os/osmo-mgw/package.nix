{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libosmocore,
  libosmo-netif,
  libosmoabis,
}:

stdenv.mkDerivation rec {
  pname = "osmo-mgw";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-mgw";
    rev = version;
    hash = "sha256-krVXADmSjPnkGiIOijaUMilSyK6uHGlyuvI9WwTnLrk=";
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
    libosmo-netif
    libosmoabis
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Osmocom Media Gateway (MGW). speaks RTP and E1 as well as MGCP";
    mainProgram = "osmo-mgw";
    homepage = "https://osmocom.org/projects/osmo-mgw";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.markuskowa ];
    platforms = lib.platforms.linux;
  };
}
