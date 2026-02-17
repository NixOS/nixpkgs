{
  fetchFromGitHub,
  lib,
  php,
  versionCheckHook,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "psysh";
  version = "0.12.20";

  src = fetchFromGitHub {
    owner = "bobthecow";
    repo = "psysh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YTKViaWBCUxerYklo22mNzrFp8M/RE3VLHrqhXuYkes=";
    forceFetchGit = true;
    postFetch = ''
      cp $out/build/composer.json $out/
      cp $out/build/composer.lock $out/
    '';
  };

  vendorHash = "sha256-2RgV+1tq+quvjDHLE+DYsi99RUJoeXjYQiR1PTLTfOw=";

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
