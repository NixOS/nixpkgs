{
  fetchFromGitHub,
  lib,
  php,
  versionCheckHook,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "psysh";
  version = "0.12.22";

  src = fetchFromGitHub {
    owner = "bobthecow";
    repo = "psysh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mcK7s/CmXTvQMNXY4bAtwWudY1aOJdt0XkOKUVhIVHQ=";
    forceFetchGit = true;
    postFetch = ''
      cp $out/build/composer.json $out/
      cp $out/build/composer.lock $out/
    '';
  };

  vendorHash = "sha256-cJT4E9gRwtuY1cziGyw5a3HsGdHc7FiRtmJWbXj2f+4=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    changelog = "https://github.com/bobthecow/psysh/releases/tag/v${finalAttrs.version}";
    description = "PsySH is a runtime developer console, interactive debugger and REPL for PHP";
    mainProgram = "psysh";
    maintainers = [ lib.maintainers.piotrkwiecinski ];
    license = lib.licenses.mit;
    homepage = "https://psysh.org/";
  };
})
