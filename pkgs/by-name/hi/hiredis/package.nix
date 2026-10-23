{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hiredis";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "redis";
    repo = "hiredis";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZUNUV31zReMA0I+jWXy6yHDLAAdcyfaxVzZmg12sAc4=";
  };

  buildInputs = [
    openssl
  ];

  env = {
    PREFIX = "\${out}";
    USE_SSL = 1;
  };

  meta = {
    homepage = "https://github.com/redis/hiredis";
    description = "Minimalistic C client for Redis >= 1.2";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    teams = [ lib.teams.redis ];
  };
})
