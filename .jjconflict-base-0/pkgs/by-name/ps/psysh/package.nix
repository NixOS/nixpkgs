{
  fetchFromGitHub,
  lib,
  php,
  versionCheckHook,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "psysh";
  version = "0.12.24";

  src = fetchFromGitHub {
    owner = "bobthecow";
    repo = "psysh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UajpFQD0M6bpOXPgHl15/QvqcSrwVD6i9i8zc5qNk0k=";
    forceFetchGit = true;
    postFetch = ''
      cp $out/build/composer.json $out/
      cp $out/build/composer.lock $out/
    '';
  };

  vendorHash = "sha256-2lALLfk3TNkF2QIlswIYcGp1sEYWdqQpSeuvyTBKsfE=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    changelog = "https://github.com/bobthecow/psysh/releases/tag/v${finalAttrs.version}";
    description = "PsySH is a runtime developer console, interactive debugger and REPL for PHP";
    mainProgram = "psysh";
    maintainers = [ lib.maintainers.piotrkwiecinski ];
    license = lib.licenses.mit;
    homepage = "https://psysh.org/";
  };
})
