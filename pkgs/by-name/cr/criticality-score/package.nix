{
  lib,
  buildGo124Module,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGo124Module rec {
  pname = "criticality-score";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "ossf";
    repo = "criticality_score";
    tag = "v${version}";
    hash = "sha256-p2ZXNpPFwIKPWDKCdEUZQvt/hvLQS9xjZaaquNTaUB0=";
  };

  proxyVendor = true;

  vendorHash = "sha256-mKCwyAE/fI9ateKcrTLDAdULbT6pUpV0cMZ0X5bqT1M=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.commit=${src.tag}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  subPackages = [
    "cmd/collect_signals"
    "cmd/criticality_score"
    "cmd/csv_transfer"
    "cmd/enumerate_github"
    "cmd/scorer"
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgram = "${placeholder "out"}/bin/${meta.mainProgram}";
  versionCheckProgramArg = "--version";

  meta = {
    description = "Gives criticality score for an open source project";
    homepage = "https://github.com/ossf/criticality_score";
    changelog = "https://github.com/ossf/criticality_score/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wamserma ];
    mainProgram = "criticality_score";
  };
}
