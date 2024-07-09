{ buildGoModule
, doppler
, fetchFromGitHub
, installShellFiles
, lib
, testers
}:

buildGoModule rec {
  pname = "doppler";
  version = "3.69.0";

  src = fetchFromGitHub {
    owner = "dopplerhq";
    repo = "cli";
    rev = version;
    sha256 = "sha256-lijVKNmqTcmjgIzlcMdm/DUrBA+0xV6Wge9dt5xdWFY=";
  };

  vendorHash = "sha256-NUHWKPszQH/pvnA+j65+bJ6t+C0FDRRbTviqkYztpE4=";

  ldflags = [
    "-s -w"
    "-X github.com/DopplerHQ/cli/pkg/version.ProgramVersion=v${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    mv $out/bin/cli $out/bin/doppler
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
