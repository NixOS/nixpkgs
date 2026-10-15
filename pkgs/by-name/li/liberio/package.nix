{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  systemd,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liberio";
  version = "0-unstable-2019-12-11";

  src = fetchFromGitHub {
    owner = "EttusResearch";
    repo = "liberio";
    rev = "81777e500d1c3b88d5048d46643fb5553eb5f786";
    hash = "sha256-82lv7ns3uMTIBceweYXPbHM5PGxQbRIgrvUk8oqkgNg=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    systemd
  ];

  doCheck = true;

  meta = {
    description = "Ettus Research DMA I/O Library";
    homepage = "https://github.com/EttusResearch/liberio";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.doronbehar ];
    platforms = lib.platforms.all;
  };
})
