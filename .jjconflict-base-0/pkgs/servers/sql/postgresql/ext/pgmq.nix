{
  lib,
  stdenv,
  fetchFromGitHub,
  postgresql,
  buildPostgresqlExtension,
}:

buildPostgresqlExtension rec {
  pname = "pgmq";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "tembo-io";
    repo = "pgmq";
    rev = "v${version}";
    hash = "sha256-ynco5t/z7+IPEynuY1wtSaoVloMr6z7UYn4byZecOhg=";
  };

  sourceRoot = "${src.name}/pgmq-extension";

  dontConfigure = true;

  meta = {
    description = "Lightweight message queue like AWS SQS and RSMQ but on Postgres";
    homepage = "https://tembo.io/pgmq";
    changelog = "https://github.com/tembo-io/pgmq/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ takeda ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.postgresql;
  };
}
