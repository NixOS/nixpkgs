{
  lib,
  fetchFromGitHub,
  nix-update-script,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phpunit";
  version = "13.2.0";

  src = fetchFromGitHub {
    owner = "sebastianbergmann";
    repo = "phpunit";
    tag = finalAttrs.version;
    hash = "sha256-BCrL70H/VVK4UnRBCqqrC33OdltLV0V2OXmpsHfDVZY=";
  };

  vendorHash = "sha256-MccgE9NEH9TKrldfdO/ahCQl0iyS2EK7i0O/glsJHV0=";

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
