{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "brev-cli";
  version = "0.6.310";

  src = fetchFromGitHub {
    owner = "brevdev";
    repo = "brev-cli";
    rev = "v${version}";
    sha256 = "sha256-dZY87iUPr1NYZNERAzuxX/en0fgefekpXAi5Um1nTBc=";
  };

  vendorHash = "sha256-7MXZVdpsPHfHk8hNZM2CT0FW8gTKt3oUap7CTVYMNfI=";

  env.CGO_ENABLED = 0;
  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=${src.rev}"
  ];

  postInstall = ''
    mv $out/bin/brev-cli $out/bin/brev
  '';

  meta = {
    description = "Connect your laptop to cloud computers";
    mainProgram = "brev";
    homepage = "https://github.com/brevdev/brev-cli";
    changelog = "https://github.com/brevdev/brev-cli/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
  };
}
