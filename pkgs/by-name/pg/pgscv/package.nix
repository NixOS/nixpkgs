{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pgscv";
<<<<<<< HEAD
  version = "0.15.1";
=======
  version = "0.15.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "CHERTS";
    repo = "pgscv";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ilYr6Q3YpAIqOKTOXhSVDyu4PXiUCgXEI8imUa4sbd4=";
  };

  vendorHash = "sha256-qn6e95yB5iaqI/B2C4eM3JGjd9MiHIrHJrAhggdCO7c=";
=======
    hash = "sha256-5n2HANuWQT1eQfz+cP0AlKLVe/aNJmGrTJ9l7l40T0k=";
  };

  vendorHash = "sha256-epQCbmfa2qlgEp0ta3FqjUlkEkq1duE0a20CSTLrS28=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
    description = "PostgreSQL ecosystem metrics collector";
    homepage = "https://github.com/CHERTS/pgscv/";
    changelog = "https://github.com/CHERTS/pgscv/releases/${version}";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ k900 ];
    mainProgram = "pgscv";
  };
}
