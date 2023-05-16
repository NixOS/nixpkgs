{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "terragrunt";
<<<<<<< HEAD
  version = "0.50.14";
=======
  version = "0.45.11";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-jPRSwq7pLFG56NB+HaP2GP2GdK1wsOeM+y396o70Q3A=";
  };

  vendorHash = "sha256-wQ5jxOTuYkiW5zHcduByKZ+vHPKn/1ELL3DskKze+UI=";
=======
    hash = "sha256-3CmaCNF8HM+vACbvjbFHZAxKnwDu1FKHJZ7YatT4bpc=";
  };

  vendorHash = "sha256-5Umoqi2D6iUk2Ut7YB/nmkOyA6Rx2qFhy/ZbfqoX5qA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
<<<<<<< HEAD
    "-X github.com/gruntwork-io/go-commons/version.Version=v${version}"
=======
    "-X main.VERSION=v${version}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/terragrunt --help
    $out/bin/terragrunt --version | grep "v${version}"
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://terragrunt.gruntwork.io";
    changelog = "https://github.com/gruntwork-io/terragrunt/releases/tag/v${version}";
    description = "A thin wrapper for Terraform that supports locking for Terraform state and enforces best practices";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ jk qjoly kashw2 ];
=======
    maintainers = with maintainers; [ jk ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
