{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "pgscv";
  version = "0.15.5";

  src = fetchFromGitHub {
    owner = "CHERTS";
    repo = "pgscv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L55GB57+Dy6L7pc4dOxnBk8vdzWAVJ+6RroE5zezEog=";
  };

  vendorHash = "sha256-aThyJ3utOLCvlnGPxK96nnxW3Y4892OL/SfSATcxeno=";

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
