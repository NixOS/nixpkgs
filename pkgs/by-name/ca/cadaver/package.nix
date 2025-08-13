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
  version = "0.27";

  src = fetchurl {
    url = "https://notroj.github.io/cadaver/cadaver-${version}.tar.gz";
    hash = "sha256-Eq/GKyPhKRJw6V6CHcqw1XRrpEYcv8hNCMKuursqtU8=";
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
