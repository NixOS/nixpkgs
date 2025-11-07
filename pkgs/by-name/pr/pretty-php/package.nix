{
  lib,
  php,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "pretty-php";
  version = "0.4.94";

  src = fetchFromGitHub {
    owner = "lkrms";
    repo = "pretty-php";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zBhxuEViLxeQ9m3u1L0wYqeL+YEWWwvJS7PtsFPO5QU=";
  };

  vendorHash = "sha256-K9ONddt0Uq6v6VwLyQORVSLo1tCt+52jDdF72Ty5umc=";

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
