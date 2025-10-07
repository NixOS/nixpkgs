{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "natscli";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "natscli";
    rev = "v${version}";
    hash = "sha256-GaP1qC90agVJa7t8aAyB+t++URxbQzkrCJ+KAVFqoBA=";
  };

  proxyVendor = true;
  vendorHash = "sha256-8Kva9aMWzGctpq51jVOz6umVTNB9NaGHIGoKmw7gl3I=";

  subPackages = [ "nats" ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  preCheck = ''
    substituteInPlace internal/asciigraph/asciigraph_test.go \
      --replace-fail "TestPlot" "SkipPlot"
  '';

  meta = {
    description = "NATS Command Line Interface";
    homepage = "https://github.com/nats-io/natscli";
    changelog = "https://github.com/nats-io/natscli/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "nats";
  };
}