{
  lib,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "harsh";
<<<<<<< HEAD
  version = "0.12.3";
=======
  version = "0.11.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "wakatara";
    repo = "harsh";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-/NgYjw/euTD55Ao91JL9og2FvHEYhDyT7mmPnJzoH4o=";
  };

  vendorHash = "sha256-dGHEP5OYr/t2JNhfIHKGXJMl8OJS5FJPXsDQXa1AiEA=";
=======
    hash = "sha256-mQhBQFDint6ZlS5yQ9oGLJVxmol9p+st9X7wRCBuc/g=";
  };

  vendorHash = "sha256-+yHIpUttvrdiTt0IuMTT4iCN34hNOb3JjZTmi5qb8yI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
