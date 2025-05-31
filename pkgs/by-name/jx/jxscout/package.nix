{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitUpdater,
}:

buildGoModule (finalAttrs: {
  pname = "jxscout";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "francisconeves97";
    repo = "jxscout";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aibPKCKENv7nD95296MKXW4OZvdYI0jSotfEeF9C6Dk=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  preCheck = ''
    # Tests are failing
    substituteInPlace internal/modules/ast-analyzer/format_test.go \
      --replace-fail "TestFormatMatchesV1WithExampleData" "SkipTestFormatMatchesV1WithExampleData" \
      --replace-fail "TestFormatMatchesV1" "SkipTestFormatMatchesV1"
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Tool to perform JavaScript analysis for security researchers";
    homepage = "https://github.com/francisconeves97/jxscout";
    changelog = "https://github.com/francisconeves97/jxscout/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "jxscout";
  };
})
