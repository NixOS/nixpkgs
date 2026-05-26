{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hiredis";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "redis";
    repo = "hiredis";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gbCLIz6nOpPbu0xbsxUVvr7XmvGdVWZQJWjpE76NIXY=";
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
    maintainers = with lib.maintainers; [ hythera ];
    platforms = lib.platforms.all;
  };
})
