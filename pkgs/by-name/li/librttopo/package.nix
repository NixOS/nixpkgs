{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  validatePkgConfig,
  geos,
}:

stdenv.mkDerivation rec {
  pname = "librttopo";
  version = "1.1.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    owner = "rttopo";
    repo = "rttopo";
    rev = "librttopo-${version}";
    hash = "sha256-VxyQr4nBy4PS2IjabBZHvzejFPDNBgSNn528ZCf99EA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    validatePkgConfig
  ];

  buildInputs = [ geos ];

  configureFlags = [
    "--with-geosconfig=${lib.getExe' (lib.getDev geos) "geos-config"}"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "RT Topology Library";
    homepage = "https://git.osgeo.org/gitea/rttopo/librttopo";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
    teams = [ lib.teams.geospatial ];
    platforms = lib.platforms.unix;
  };
}
