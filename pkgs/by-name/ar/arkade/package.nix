{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "arkade";
<<<<<<< HEAD
  version = "0.11.60";
=======
  version = "0.11.59";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "alexellis";
    repo = "arkade";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-2VabFPcvTgkjoGXQDUdDh1BdUB+tS3QsfGDSGerd95Q=";
=======
    hash = "sha256-tmn75g4hfayU7zDaP7QPIv46tHHxFgB0ebATS+fYHgI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  env.CGO_ENABLED = 0;

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = null;

  # Exclude pkg/get: tests downloading of binaries which fail when sandbox=true
  subPackages = [
    "."
    "cmd"
    "pkg/apps"
    "pkg/archive"
    "pkg/config"
    "pkg/env"
    "pkg/helm"
    "pkg/k8s"
    "pkg/types"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/alexellis/arkade/pkg.GitCommit=ref/tags/${version}"
    "-X github.com/alexellis/arkade/pkg.Version=${version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd arkade \
      --bash <($out/bin/arkade completion bash) \
      --zsh <($out/bin/arkade completion zsh) \
      --fish <($out/bin/arkade completion fish)
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/alexellis/arkade";
    description = "Open Source Kubernetes Marketplace";
    mainProgram = "arkade";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    homepage = "https://github.com/alexellis/arkade";
    description = "Open Source Kubernetes Marketplace";
    mainProgram = "arkade";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      welteki
      techknowlogick
      qjoly
    ];
  };
}
