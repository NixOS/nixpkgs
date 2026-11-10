{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "pgscv";
  version = "0.15.3";

  src = fetchFromGitHub {
    owner = "CHERTS";
    repo = "pgscv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xU06W4364pozLfK4viFRyclrqTXnSQoGmwNTwwiUH10=";
  };

  vendorHash = "sha256-MYju9DexwrVSGBg70knry0qfYxjkif/sDLEKWNDygnM=";

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
