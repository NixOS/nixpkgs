{
  buildGoModule,
  doppler,
  fetchFromGitHub,
  installShellFiles,
  lib,
  testers,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "doppler";
  version = "3.76.5";

  src = fetchFromGitHub {
    owner = "dopplerhq";
    repo = "cli";
    rev = finalAttrs.version;
    hash = "sha256-98RBpWjBzsLSFTarI5fyc26oyAIuGl5Sm5PeqW3RU0A=";
  };

  vendorHash = "sha256-rDpr4qWhMWXEhgZrmoW5tzPZif3KAv3gDtJNtXzbVq0=";

  ldflags = [
    "-s -w"
    "-X github.com/DopplerHQ/cli/pkg/version.ProgramVersion=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    mv $out/bin/cli $out/bin/doppler
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    export HOME=$TMPDIR
    mkdir $HOME/.doppler # to avoid race conditions below
    installShellCompletion --cmd doppler \
      --bash <($out/bin/doppler completion bash) \
      --fish <($out/bin/doppler completion fish) \
      --zsh <($out/bin/doppler completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = doppler;
    version = "v${finalAttrs.version}";
  };

  meta = {
    description = "Official CLI for interacting with your Doppler Enclave secrets and configuration";
    mainProgram = "doppler";
    homepage = "https://doppler.com";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lucperkins ];
  };
})
