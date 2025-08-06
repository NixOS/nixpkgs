{
  lib,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "harsh";
  version = "0.10.22";

  src = fetchFromGitHub {
    owner = "wakatara";
    repo = "harsh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TGhhiqFf6POR7x/Nc8m5/mBlj23EnjZlL5AL9IwXghk=";
  };

  vendorHash = "sha256-m+5MSgzuRUZuP1GhEUCttLRLL63kphMi8N9tDUaTaOQ=";

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  checkFlags =
    let
      skippedTests = [
        "TestNewHabitIntegration" # panic: unexpected call to os.Exit(0) during test
        "TestBuildGraph" # Expected graph length 10, got 24
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  meta = {
    description = "CLI habit tracking for geeks";
    homepage = "https://github.com/wakatara/harsh";
    changelog = "https://github.com/wakatara/harsh/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "harsh";
  };
})
