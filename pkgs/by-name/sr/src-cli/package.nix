{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  xorg,
  testers,
  src-cli,
}:

buildGoModule rec {
  pname = "src-cli";
<<<<<<< HEAD
  version = "6.11.0";
=======
  version = "6.10.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "src-cli";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-uJAiNBrZmaDV7Etr3xAkDHXs7H9YZYLsyTcnaHGVJfI=";
  };

  vendorHash = "sha256-H8xJtlAWkk7AcZBYR/xggs/Ut0cnHC49XiScEcdlkMc=";
=======
    hash = "sha256-x35ER65LNw3049JLrRA5SyPjUYh/zXhRJM8FIp9iW60=";
  };

  vendorHash = "sha256-rsmgKSmgjtxeNhTrwA7RBtNAa7qyDKhbKSVmfP5AgFg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  subPackages = [
    "cmd/src"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/sourcegraph/src-cli/internal/version.BuildTag=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = src-cli;
      command = "src version -client-only";
    };
  };

<<<<<<< HEAD
  meta = {
    description = "Sourcegraph CLI";
    homepage = "https://github.com/sourcegraph/src-cli";
    changelog = "https://github.com/sourcegraph/src-cli/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Sourcegraph CLI";
    homepage = "https://github.com/sourcegraph/src-cli";
    changelog = "https://github.com/sourcegraph/src-cli/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      keegancsmith
    ];
    mainProgram = "src";
  };
}
