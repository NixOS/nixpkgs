{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGo127Module,
  buildPackages,
  installShellFiles,
  writableTmpDirAsHomeHook,
}:

buildGo127Module (finalAttrs: {
  pname = "circleci-cli";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "CircleCI-Public";
    repo = "circleci-cli";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-UzstpYb1YJ9LRk4FzL43suIUSJbZkUo9KlOb1h2CNhk=";
  };

  vendorHash = "sha256-JhQkQi9JLHqo6gW9gvdwPqb0XRBw0XH/b3oUcZC5giw=";

  subPackages = [ "cmd/circleci" ];

  nativeBuildInputs = [
    installShellFiles
    writableTmpDirAsHomeHook
  ];

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd circleci \
        --bash <(${emulator} $out/bin/circleci completion bash) \
        --zsh <(${emulator} $out/bin/circleci completion zsh) \
        --fish <(${emulator} $out/bin/circleci completion fish)

      ${emulator} $out/bin/circleci man --output $TMPDIR/circleci.1
      installManPage $TMPDIR/circleci.1
    ''
  );

  meta = {
    # Box blurb edited from the AUR package circleci-cli
    description = ''
      Command to enable you to reproduce the CircleCI environment locally and
      run jobs as if they were running on the hosted CircleCI application.
    '';
    maintainers = with lib.maintainers; [ stig ];
    mainProgram = "circleci";
    license = lib.licenses.mit;
    homepage = "https://cli.circleci.com";
  };
})
