{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

buildGo127Module (finalAttrs: {
  pname = "augustus-go";
  version = "0.14.57";

  src = fetchFromGitHub {
    owner = "praetorian-inc";
    repo = "augustus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8U1j2sw+CVibYJwE8w9cI3P7x5YCWwpdIrDI3Hskxko=";
  };

  vendorHash = "sha256-kbNNUx8WBe61WtnTMmKmGmAI/DUOIh+ZfMYNN4D4aHU=";

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  ldflags = [ "-s" ];

  preCheck = ''
    # We don't care about Benchmarks
    rm -r benchmarks
    # Assert mismatch
    substituteInPlace internal/detectors/packagehallucination/rubygems_test.go \
      --replace-fail "TestRubyGems_Detect_FakeGem" "Skip_TestRubyGems_Detect_FakeGem"
    # Tests require network access
    rm internal/generators/bedrock/bedrock_test.go
    rm internal/generators/bedrock/nova_test.go
  '';

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "LLM security testing framework for detecting prompt injection, jailbreaks and adversarial attacks";
    homepage = "https://github.com/praetorian-inc/augustus";
    changelog = "https://github.com/praetorian-inc/augustus/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "augustus";
  };
})
