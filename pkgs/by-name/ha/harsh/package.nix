{
  lib,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "harsh";
  version = "0.10.20";

  src = fetchFromGitHub {
    owner = "wakatara";
    repo = "harsh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M/SnCZFYeJGS96bwfc5rpqvYfkA9Bqu9DRfXHhHq710=";
  };

  vendorHash = "sha256-/OPeNpxoTT1uYajri1nYleH+PmwgBIkaq7iBYaQ/yb8=";

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
