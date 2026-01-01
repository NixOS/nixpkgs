{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "omnictl";
<<<<<<< HEAD
  version = "1.4.6";
=======
  version = "1.3.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "siderolabs";
    repo = "omni";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-p2DKfDf76xr42LLvtVFrSfxJkrpOeFUhtrViI/cD66Y=";
  };

  vendorHash = "sha256-lVUe1XQr46uzx3kfj7KmoiGFUGEb7UT16IQSI8In8RU=";
=======
    hash = "sha256-anQujIC4+XU04fv6IMkwusPF7EQ90+w9xuqdFb/fEzU=";
  };

  vendorHash = "sha256-ew94A1GrUtuKqLIFDCkuAj1oOQV7nd8tdz4PAA8gax0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-w"
  ];

  env.GOWORK = "off";

  subPackages = [ "cmd/omnictl" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd omnictl \
      --bash <($out/bin/omnictl completion bash) \
      --fish <($out/bin/omnictl completion fish) \
      --zsh <($out/bin/omnictl completion zsh)
  '';

  doCheck = false; # no tests

<<<<<<< HEAD
  meta = {
    description = "CLI for the Sidero Omni Kubernetes management platform";
    mainProgram = "omnictl";
    homepage = "https://omni.siderolabs.com/";
    license = lib.licenses.bsl11;
    maintainers = with lib.maintainers; [ raylas ];
=======
  meta = with lib; {
    description = "CLI for the Sidero Omni Kubernetes management platform";
    mainProgram = "omnictl";
    homepage = "https://omni.siderolabs.com/";
    license = licenses.bsl11;
    maintainers = with maintainers; [ raylas ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
