{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hiredis";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "redis";
    repo = "hiredis";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ZxUITm3OcbERcvaNqGQU46bEfV+jN6safPalG0TVfBg=";
  };

  buildInputs = [
    openssl
  ];

  PREFIX = "\${out}";
  USE_SSL = 1;

  meta = {
    homepage = "https://github.com/redis/hiredis";
    description = "Minimalistic C client for Redis >= 1.2";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
})
