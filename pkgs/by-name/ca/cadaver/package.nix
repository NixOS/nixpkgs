{
  lib,
  stdenv,
  fetchurl,
  neon,
  pkg-config,
  zlib,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "cadaver";
  version = "0.28";

  src = fetchurl {
    url = "https://notroj.github.io/cadaver/cadaver-${version}.tar.gz";
    hash = "sha256-M+OlS9VLHrMltIMWp8rMJAR8Uz74jm75i4jfu2DhJzQ=";
  };

  configureFlags = [
    "--with-ssl"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    neon
    openssl
    zlib
  ];

  meta = {
    description = "Command-line WebDAV client";
    homepage = "https://notroj.github.io/cadaver/";
    changelog = "https://github.com/notroj/cadaver/blob/${version}/NEWS";
    maintainers = with lib.maintainers; [ ianwookim ];
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; linux ++ freebsd ++ openbsd;
    mainProgram = "cadaver";
  };
}
