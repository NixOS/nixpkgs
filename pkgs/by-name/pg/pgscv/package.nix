{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pgscv";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "CHERTS";
    repo = "pgscv";
    tag = "v${version}";
    hash = "sha256-jUTHaZvJ6O3dVhBGO+ZFT9A7KmKieR2viGhZXwOv5S8=";
  };

  vendorHash = "sha256-v4Xi2R+q2jGD3Fy6xvKNRaf+P725acr+tvdDxod2KiI=";

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
