{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pgscv";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "CHERTS";
    repo = "pgscv";
    tag = "v${version}";
    hash = "sha256-ON1/ShMnBIC7t1b8ejZR74BtEZNG/0EhgwurhkGoIxA=";
  };

  vendorHash = "sha256-T4XlNhLgPE28S+TUWM+f38iVumxkk3Ku9qFzPJ2zQY4=";

  ldflags = [
    "-X=main.appName=pgscv"
    "-X=main.gitTag=${src.tag}"
    "-X=main.gitCommit=${src.tag}"
    "-X=main.gitBranch=${src.tag}"
  ];

  # tests rely on a pretty complex Postgres setup
  doCheck = false;

  postInstall = ''
    mv $out/bin/{cmd,pgscv}
  '';

  meta = {
    description = "PgSCV is a PostgreSQL ecosystem metrics collector";
    homepage = "https://github.com/CHERTS/pgscv/";
    changelog = "https://github.com/CHERTS/pgscv/releases/${version}";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ k900 ];
    mainProgram = "pgscv";
  };
}
