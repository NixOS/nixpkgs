{
  lib,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "harsh";
  version = "0.10.21";

  src = fetchFromGitHub {
    owner = "wakatara";
    repo = "harsh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aACbq88WDZ4ArdQRoeIBQLVbTosAsZqftajEfkKat7E=";
  };

  vendorHash = "sha256-fggoN0PcPnfig3TA6662TPFNh/6cZVdmyr7atewoGYQ=";

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
