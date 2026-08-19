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
  version = "0.5.4";

  src = fetchFromCodeberg {
    owner = "abrenneke";
    repo = "jj-vine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rgTFo4mrGlIe7lfwpT0P7r5RBjD/XaX2S4AOp+oUaqY=";
  };

  cargoHash = "sha256-7j/eWCc5PvllLYSyC2CcL+R5xxDqqfjdhQ/xtb2b3rE=";

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
