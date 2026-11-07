{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  openssl,
  odbcSupport ? true,
  unixodbc ? null,
}:

assert odbcSupport -> unixodbc != null;

# Work is in progress to move to cmake so revisit that later

stdenv.mkDerivation (finalAttrs: {
  pname = "freetds";
  version = "1.5.20";

  src = fetchurl {
    url = "https://www.freetds.org/files/stable/freetds-${finalAttrs.version}.tar.bz2";
    hash = "sha256-OZqGgPdxZP8GvsV67v3/S7FgQG5QnNfMMEdD0n6vuyM=";
  };

  patches = [
    ./gettext-0.25.patch
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optional odbcSupport unixodbc;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  meta = {
    description = "Libraries to natively talk to Microsoft SQL Server and Sybase databases";
    homepage = "https://www.freetds.org";
    changelog = "https://github.com/FreeTDS/freetds/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.lgpl2;
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.all;
  };
})
