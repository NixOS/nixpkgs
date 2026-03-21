{
  lib,
  fetchgit,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "composer-require-checker";
  version = "4.22.0";

  # Upstream no longer provides the composer.lock in their release artifact
  src = fetchgit {
    url = "https://github.com/maglnet/ComposerRequireChecker";
    tag = finalAttrs.version;
    hash = "sha256-L/jhVJxZOa3oIahVI85VoueFHUIuzKsQGum4127Psbg=";
  };

  vendorHash = "sha256-aAXFEtlQ89k7GjSQOPkN5kRg0GbAO46MACSzDL9LK34=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "CLI tool to check whether a specific composer package uses imported symbols that aren't part of its direct composer dependencies";
    homepage = "https://github.com/maglnet/ComposerRequireChecker/";
    changelog = "https://github.com/maglnet/ComposerRequireChecker/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [ mit ];
    mainProgram = "composer-require-checker";
    maintainers = [ lib.maintainers.patka ];
  };
})
