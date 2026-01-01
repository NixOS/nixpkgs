{
  lib,
  php,
  fetchFromGitHub,
<<<<<<< HEAD
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "pretty-php";
  version = "0.4.95";
=======
  testers,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "pretty-php";
  version = "0.4.94";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "lkrms";
    repo = "pretty-php";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-V+xncL02fY0olGxqjWBWqD6N1J0XOeOPe55aULuN2bA=";
  };

  vendorHash = "sha256-r5LhN2OjEpiHR0RtK7d/pMd8bqFJbM8CuCXEDGjgG4A=";

  nativeBuildInputs = [ writableTmpDirAsHomeHook ];
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgramArg = "--version";
=======
    hash = "sha256-zBhxuEViLxeQ9m3u1L0wYqeL+YEWWwvJS7PtsFPO5QU=";
  };

  vendorHash = "sha256-Y1/wNFPXza2aO07ZFybpwI3XbTVBhEvFHs9ygHQbcSo=";

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "HOME=$TMPDIR pretty-php --version";
    };
  };
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Opinionated PHP code formatter";
    homepage = "https://github.com/lkrms/pretty-php";
    license = lib.licenses.mit;
    mainProgram = "pretty-php";
    maintainers = with lib.maintainers; [ piotrkwiecinski ];
  };
})
