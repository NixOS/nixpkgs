{
  buildGoModule,
  doppler,
  fetchFromGitHub,
  installShellFiles,
  lib,
  testers,
  stdenv,
}:

buildGoModule rec {
  pname = "doppler";
  version = "3.75.1";

  src = fetchFromGitHub {
    owner = "dopplerhq";
    repo = "cli";
    rev = version;
    hash = "sha256-YyhDvBgdcy3CtVpQj60XQ0aqE2zT1LV9QXQJiJvlaic=";
  };

  vendorHash = "sha256-tSRtgkDPvDlEfwuNhahvs3Pvt4h7QAJrJtb1XQXGaFM=";

  ldflags = [
    "-s -w"
    "-X github.com/DopplerHQ/cli/pkg/version.ProgramVersion=v${version}"
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
    version = "v${version}";
  };

  meta = with lib; {
    description = "Official CLI for interacting with your Doppler Enclave secrets and configuration";
    mainProgram = "doppler";
    homepage = "https://doppler.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
  };
}
