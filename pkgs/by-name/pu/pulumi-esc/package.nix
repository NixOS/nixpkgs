{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pulumi-esc";
<<<<<<< HEAD
  version = "0.21.0";
=======
  version = "0.19.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "esc";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-oTCCPwdepaZif2LJfJtBuw4jQDUwDU+wGNgl+mB52Ko=";
=======
    hash = "sha256-TsYMGPL4Lru7T1p4v/gaql665JO2LIKayb3GupxYbiI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  subPackages = "cmd/esc";

<<<<<<< HEAD
  vendorHash = "sha256-QDevyfNos1+kZmBJDKQH43EJ66XyrRPjdAkrhRqFJNU=";
=======
  vendorHash = "sha256-IcQaWo5/EoPJjn5pDKwHjd56JeareznE7iSansJIfso=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pulumi/esc/cmd/esc/cli/version.Version=${src.rev}"
  ];

<<<<<<< HEAD
  meta = {
    description = "Pulumi ESC (Environments, Secrets, and Configuration) for cloud applications and infrastructure";
    homepage = "https://github.com/pulumi/esc/tree/main";
    changelog = "https://github.com/pulumi/esc/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    description = "Pulumi ESC (Environments, Secrets, and Configuration) for cloud applications and infrastructure";
    homepage = "https://github.com/pulumi/esc/tree/main";
    changelog = "https://github.com/pulumi/esc/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ yomaq ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "esc";
  };
}
