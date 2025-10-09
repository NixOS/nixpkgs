{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "natscli";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "natscli";
    tag = "v${version}";  # Changed back to 'tag' as per reviewer feedback
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

  nativeInstallCheckInputs = [ versionCheckHook ];  # Added back as per reviewer feedback

  preCheck = ''
    # Remove tests that depend on CLI output  # Added back the comment as per reviewer feedback
    substituteInPlace internal/asciigraph/asciigraph_test.go \
      --replace-fail "TestPlot" "SkipPlot"
  '';

  doInstallCheck = true;  # Added back this line since we're using versionCheckHook

  versionCheckProgram = "${placeholder "out"}/bin/nats";  # Added back this line since we're using versionCheckHook

  meta = {
    description = "NATS Command Line Interface";
    homepage = "https://github.com/nats-io/natscli";
    changelog = "https://github.com/nats-io/natscli/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "nats";
  };
}