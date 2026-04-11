{
  lib,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "harsh";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "wakatara";
    repo = "harsh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Dyq6/Soc6J8rmqwvRtgz/H/l9gtSkEb6Ep/CxUteln4=";
  };

  vendorHash = "sha256-yMiw/D1poesgkvJa4jUclityEfhBxhLUTffBnkoWLHw=";

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
