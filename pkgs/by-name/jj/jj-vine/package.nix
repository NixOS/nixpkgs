{
  lib,
  rustPlatform,
  fetchFromCodeberg,
  jujutsu,
  git,
  writableTmpDirAsHomeHook,
  cacert,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jj-vine";
  version = "0.5.0";

  src = fetchFromCodeberg {
    owner = "abrenneke";
    repo = "jj-vine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uvnSv+4ijVdBoHrOklDRY+JDLsVOTRu+laOcFMjkYaA=";
  };

  cargoHash = "sha256-TsyFWcvr8ksiC1vStWs+mH88lw1/JGRg8IQ7XFnZ5qg=";

  nativeCheckInputs = [
    jujutsu
    git
    writableTmpDirAsHomeHook
  ];
  checkFeatures = [ "no-e2e-tests" ];
  env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for submitting stacked Pull/Merge Requests from Jujutsu bookmarks";
    homepage = "https://codeberg.org/abrenneke/jj-vine";
    changelog = "https://codeberg.org/abrenneke/jj-vine/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "jj-vine";
    maintainers = with lib.maintainers; [ winter ];
  };
})
