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
  version = "0.5.3";

  src = fetchFromCodeberg {
    owner = "abrenneke";
    repo = "jj-vine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dUamfoMtdDNz9xmXeg1O1j5UHW6uF/1WznHSsG+eVjs=";
  };

  cargoHash = "sha256-nuj0cugeK5oc+sZmm1f5dvGEjML0qkle5uO66e54VIY=";

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
