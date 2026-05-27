{
  lib,
  php,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "pretty-php";
  version = "0.4.95";

  src = fetchFromGitHub {
    owner = "lkrms";
    repo = "pretty-php";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V+xncL02fY0olGxqjWBWqD6N1J0XOeOPe55aULuN2bA=";
  };

  vendorHash = "sha256-r5LhN2OjEpiHR0RtK7d/pMd8bqFJbM8CuCXEDGjgG4A=";

  nativeBuildInputs = [ writableTmpDirAsHomeHook ];
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Opinionated PHP code formatter";
    homepage = "https://github.com/lkrms/pretty-php";
    license = lib.licenses.mit;
    mainProgram = "pretty-php";
    maintainers = with lib.maintainers; [ piotrkwiecinski ];
  };
})
