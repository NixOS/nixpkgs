{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "augustus-go";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "praetorian-inc";
    repo = "augustus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yC7Wxx7PCWLpIMdXieks7oTdW5Ot6e6zIJHnRyZUOlo=";
  };

  vendorHash = "sha256-4PQX87yICvP6h4IPjFTWnhbftPBx53im95V0oiL3v6E=";

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
