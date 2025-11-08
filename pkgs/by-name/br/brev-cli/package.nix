{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "brev-cli";
  version = "0.6.314";

  src = fetchFromGitHub {
    owner = "brevdev";
    repo = "brev-cli";
    rev = "v${version}";
    sha256 = "sha256-/EzRKmpfQndZFL3c82u0w0V8EH/TFptU3zkHPvsIM6s=";
  };

  vendorHash = "sha256-CzGuEbq4I1ygYQsoyyXC6gDBMLg21dKQTKkrbwpAR2U=";

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
