{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "pgscv";
  version = "0.15.4";

  src = fetchFromGitHub {
    owner = "CHERTS";
    repo = "pgscv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CZc3JSiUYnDNHsQUweAev1wf3qW4rsdAC0WF7JPPEfo=";
  };

  vendorHash = "sha256-lMyC2MLc12IxqO6rR/a6h639wCm5qsg4+8gnjJDL7eg=";

  ldflags = [
    "-X=main.appName=pgscv"
    "-X=main.gitTag=${finalAttrs.src.tag}"
    "-X=main.gitCommit=${finalAttrs.src.tag}"
    "-X=main.gitBranch=${finalAttrs.src.tag}"
  ];

  # tests rely on a pretty complex Postgres setup
  doCheck = false;

  postInstall = ''
    mv $out/bin/{cmd,pgscv}
  '';

  meta = {
    description = "PostgreSQL ecosystem metrics collector";
    homepage = "https://github.com/CHERTS/pgscv/";
    changelog = "https://github.com/CHERTS/pgscv/releases/${finalAttrs.version}";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ k900 ];
    mainProgram = "pgscv";
  };
})
