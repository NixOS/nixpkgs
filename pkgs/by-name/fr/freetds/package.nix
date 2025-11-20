{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  openssl,
  odbcSupport ? true,
  unixODBC ? null,
}:

assert odbcSupport -> unixODBC != null;

# Work is in progress to move to cmake so revisit that later

stdenv.mkDerivation rec {
  pname = "freetds";
  version = "1.5.8";

  src = fetchurl {
    url = "https://www.freetds.org/files/stable/${pname}-${version}.tar.bz2";
    hash = "sha256-TnqK/oPpVBlwhOPSEnvh437p3V3rDZ5wVGfmDsc95N8=";
  };

  patches = [
    ./gettext-0.25.patch
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optional odbcSupport unixODBC;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  meta = {
    description = "Libraries to natively talk to Microsoft SQL Server and Sybase databases";
    homepage = "https://www.freetds.org";
    changelog = "https://github.com/FreeTDS/freetds/releases/tag/v${version}";
    license = lib.licenses.lgpl2;
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.all;
  };
}
