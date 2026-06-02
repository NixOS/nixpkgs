{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libosmocore,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "osmo-ggsn";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-ggsn";
    rev = finalAttrs.version;
    hash = "sha256-/t5BqZYbeQb2Aea7fSJSJ4ZY2kG/6BtqHeCfFdfo4VA=";
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
    description = "Osmocom Gateway GPRS Support Node (GGSN), successor of OpenGGSN";
    homepage = "https://osmocom.org/projects/openggsn";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.markuskowa ];
    platforms = lib.platforms.linux;
    mainProgram = "osmo-ggsn";
  };
})
