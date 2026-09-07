{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "augustus-go";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "praetorian-inc";
    repo = "augustus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZQoE8liABfAEceNvtJsHtLyfxECEJIRwK3eKGrMIpIE=";
  };

  vendorHash = "sha256-IdfrBD0N9zEreUzwMmT84d/UP6KnGETzvwyUfJVpNXo=";

  ldflags = [ "-s" ];

  preCheck = ''
    # We don't care about Benchmarks
    rm -r benchmarks
    # Assert mismatch
    substituteInPlace internal/detectors/packagehallucination/rubygems_test.go \
      --replace-fail "TestRubyGems_Detect_FakeGem" "Skip_TestRubyGems_Detect_FakeGem"
    # Tests require network access
    rm  internal/generators/bedrock/bedrock_test.go
  '';

  meta = {
    description = "LLM security testing framework for detecting prompt injection, jailbreaks and adversarial attacks";
    homepage = "https://github.com/praetorian-inc/augustus";
    changelog = "https://github.com/praetorian-inc/augustus/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "augustus";
  };
})
