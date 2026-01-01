{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "sqls";
<<<<<<< HEAD
  version = "0.2.30";
=======
  version = "0.2.28";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "sqls-server";
    repo = "sqls";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-vsU0EZZ7Wwo2esv7StmSB4DbQXCwp4Mi+KsylCL0WcM=";
  };

  vendorHash = "sha256-BSGKFSw/ReeADnB3FuEJoxstkCcJx434vNaFf5A+Gbw=";
=======
    hash = "sha256-b3zLyj2n+eKOPBRooS68GfM0bsiTVXDblYKyBYKiYug=";
  };

  vendorHash = "sha256-6IFJvdT7YLnWsg7Icd3nKXXHM6TZKZ+IG9nEBosRCwA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.revision=${src.rev}"
  ];

  doCheck = false;

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/sqls-server/sqls";
    description = "SQL language server written in Go";
    mainProgram = "sqls";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vinnymeller ];
=======
  meta = with lib; {
    homepage = "https://github.com/sqls-server/sqls";
    description = "SQL language server written in Go";
    mainProgram = "sqls";
    license = licenses.mit;
    maintainers = with maintainers; [ vinnymeller ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
