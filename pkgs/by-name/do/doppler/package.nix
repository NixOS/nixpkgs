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
  version = "3.75.2";

  src = fetchFromGitHub {
    owner = "dopplerhq";
    repo = "cli";
    rev = finalAttrs.version;
    hash = "sha256-S6g2wtF676Cc3nEKP1GpyhQRYyjKUQa9ACe41269vHY=";
  };

  vendorHash = "sha256-u6SB3SXCqu7Y2aUoTAJ01mtDCxMofVQLAde1jDxVvks=";

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
