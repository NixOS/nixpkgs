{
  fetchFromGitHub,
  lib,
  php,
  versionCheckHook,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "psysh";
  version = "0.12.21";

  src = fetchFromGitHub {
    owner = "bobthecow";
    repo = "psysh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/qY7o7gsO0SdDzf9sfWFDpO/fjX3tSAoKsTeSGQ65HM=";
    forceFetchGit = true;
    postFetch = ''
      cp $out/build/composer.json $out/
      cp $out/build/composer.lock $out/
    '';
  };

  vendorHash = "sha256-gYFix4QRVuUne+brU/Vfa1sS6tiUPAu8NRE7c4WUBPU=";

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
