{
  lib,
  stdenv,
  fetchFromGitHub,
  cjson,
  cmake,
  docutils,
  libev,
  openssl,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pgagroal";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "agroal";
    repo = "pgagroal";
    rev = finalAttrs.version;
    hash = "sha256-bgJvGJ35RdFopW88o+H1DLpG70anP197y6xrpRRrxUA=";
  };

  patches = [ ./do-not-search-libatomic.patch ];

  nativeBuildInputs = [
    cmake
    docutils
  ];

  buildInputs = [
    cjson
    libev
    openssl
  ] ++ lib.optionals stdenv.isLinux [ systemd ];

  meta = with lib; {
    description = "High-performance connection pool for PostgreSQL";
    homepage = "https://agroal.github.io/pgagroal/";
    changelog = "https://github.com/agroal/pgagroal/releases/tag/${finalAttrs.version}";
    license = licenses.bsd3;
    maintainers = [ ];
    platforms = platforms.unix;
  };
})
