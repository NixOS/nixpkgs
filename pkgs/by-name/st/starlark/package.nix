{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:
buildGoModule {
  pname = "starlark";
<<<<<<< HEAD
  version = "0-unstable-2025-12-22";
=======
  version = "0-unstable-2025-11-09";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "google";
    repo = "starlark-go";
<<<<<<< HEAD
    rev = "15019ee33dea8b618e081116e29a613c9aa050ea";
    hash = "sha256-BIWOmJwtTxjXTc48Mamm6uqPTNd7DMeURfQ2rYX4Ecs=";
=======
    rev = "be02852a5e1f2f07f08e887a191e725154c029b8";
    hash = "sha256-Njq60qM+2AigXZB3AAWV5mpN2uxDXJSsjJTPlMvYw5k=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  vendorHash = "sha256-8drlCBy+KROyqXzm/c+HBe/bMVOyvwRoLHxOApJhMfo=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    homepage = "https://github.com/google/starlark-go";
    description = "Interpreter for Starlark, implemented in Go";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "starlark";
  };
}
