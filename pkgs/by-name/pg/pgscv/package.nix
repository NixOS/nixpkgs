{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pgscv";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "CHERTS";
    repo = "pgscv";
    tag = "v${version}";
    hash = "sha256-6qhJZHyVtEI4+pqi0dgagDC2RaISV9g/ygrezJO57Sk=";
  };

  vendorHash = "sha256-KahDpLwk+6KXaIfvjr7+nkFuEV4Dw3pyshkJ5XUEdUg=";

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
