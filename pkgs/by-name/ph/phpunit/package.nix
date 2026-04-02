{
  lib,
  fetchFromGitHub,
  nix-update-script,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phpunit";
  version = "13.0.6";

  src = fetchFromGitHub {
    owner = "sebastianbergmann";
    repo = "phpunit";
    tag = finalAttrs.version;
    hash = "sha256-leSHb+G5zzYOw0AbQRbB8bIcKS4kvIY/6TGDFBto/9o=";
  };

  vendorHash = "sha256-uUENOq9BEX0vZU3PBc7+nL4IkUx/R2QTO+COT6oNsPM=";

  passthru = {
    updateScript = nix-update-script { };
  };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    changelog = "https://github.com/sebastianbergmann/phpunit/blob/${finalAttrs.version}/ChangeLog-${lib.versions.majorMinor finalAttrs.version}.md";
    description = "PHP Unit Testing framework";
    homepage = "https://phpunit.de";
    license = lib.licenses.bsd3;
    mainProgram = "phpunit";
    maintainers = with lib.maintainers; [
      onny
      patka
    ];
  };
})
