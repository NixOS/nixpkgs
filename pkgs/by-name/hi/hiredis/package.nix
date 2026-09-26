{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hiredis";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "redis";
    repo = "hiredis";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Z5aiwCJ6a5SB0pAtGRtKH31CUA8XBB4hytFFCmENrv4=";
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
