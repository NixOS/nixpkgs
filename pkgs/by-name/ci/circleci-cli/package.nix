{
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "circleci-cli";
  version = "0.1.34422";

  src = fetchFromGitHub {
    owner = "CircleCI-Public";
    repo = "circleci-cli";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-uBMgg/ON1klZBbSqSxfM4Kg7EXPVu/uHqrYg/QlY6oM=";
  };

  vendorHash = "sha256-GRWo9oq8M7zJoWCg6iNLbR+DPXvMXF3v+YRU2BBH5+8=";

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/CircleCI-Public/circleci-cli/version.Version=${finalAttrs.version}"
    "-X github.com/CircleCI-Public/circleci-cli/version.Commit=${finalAttrs.src.rev}"
    "-X github.com/CircleCI-Public/circleci-cli/version.packageManager=nix"
  ];

  postInstall = ''
    mv $out/bin/circleci-cli $out/bin/circleci

    installShellCompletion --cmd circleci \
      --bash <(HOME=$TMPDIR $out/bin/circleci completion bash --skip-update-check) \
      --zsh <(HOME=$TMPDIR $out/bin/circleci completion zsh --skip-update-check)
  '';

  meta = {
    # Box blurb edited from the AUR package circleci-cli
    description = ''
      Command to enable you to reproduce the CircleCI environment locally and
      run jobs as if they were running on the hosted CirleCI application.
    '';
    maintainers = with lib.maintainers; [ synthetica ];
    mainProgram = "circleci";
    license = lib.licenses.mit;
    homepage = "https://circleci.com/";
  };
})
