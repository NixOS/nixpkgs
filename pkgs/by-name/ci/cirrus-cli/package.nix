{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule rec {
  pname = "cirrus-cli";
<<<<<<< HEAD
  version = "0.158.0";
=======
  version = "0.156.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "cirruslabs";
    repo = "cirrus-cli";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-VrF5Mp+InnStjEQaNXNvveImubxysRlRjrIq+SN6h3o=";
  };

  vendorHash = "sha256-+3EWlbOr6MGx5M8IP28ZbTZYp+9lpmi+q5bBmnTDGoA=";
=======
    hash = "sha256-9ha87R/TN0Tjl4VWoCEMKc+hnSTcFaeIURndrF2uMR0=";
  };

  vendorHash = "sha256-czH0s9zxj6A8RMa4i6u3+2rIr8vfBe9ECTnAbQ7kK5E=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-X github.com/cirruslabs/cirrus-cli/internal/version.Version=v${version}"
    "-X github.com/cirruslabs/cirrus-cli/internal/version.Commit=v${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd cirrus \
      --bash <($out/bin/cirrus completion bash) \
      --zsh <($out/bin/cirrus completion zsh) \
      --fish <($out/bin/cirrus completion fish)
  '';

  # tests fail on read-only filesystem
  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "CLI for executing Cirrus tasks locally and in any CI";
    homepage = "https://github.com/cirruslabs/cirrus-cli";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ techknowlogick ];
=======
  meta = with lib; {
    description = "CLI for executing Cirrus tasks locally and in any CI";
    homepage = "https://github.com/cirruslabs/cirrus-cli";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ techknowlogick ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "cirrus";
  };
}
