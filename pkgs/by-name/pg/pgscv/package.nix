{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pgscv";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "CHERTS";
    repo = "pgscv";
    tag = "v${version}";
    hash = "sha256-BWGRighkezG3zjhyiYEFTeVvWps4q9+9xjk9EPHI/B0=";
  };

  vendorHash = "sha256-UEqJz7xKBQaBrBI3mV8W+WtLGDDf3EaV7NzEPofW+TE=";

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
