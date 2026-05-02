{
  lib,
  rustPlatform,
  fetchFromCodeberg,
  jujutsu,
  git,
  writableTmpDirAsHomeHook,
  cacert,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jj-vine";
  version = "0.4.0";

  src = fetchFromCodeberg {
    owner = "abrenneke";
    repo = "jj-vine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-//hBF2KoDe3bNzXQVxfB26cI8Cc6lZUwkDOZJ2clprI=";
  };

  cargoHash = "sha256-ICBwMJMeGdpPNWXxBRKk+TNe1kubB0U/XgxXdeYirLA=";

  nativeCheckInputs = [
    jujutsu
    git
    writableTmpDirAsHomeHook
  ];
  checkFeatures = [ "no-e2e-tests" ];
  env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  meta = {
    description = "Tool for submitting stacked Pull/Merge Requests from Jujutsu bookmarks";
    homepage = "https://codeberg.org/abrenneke/jj-vine";
    changelog = "https://codeberg.org/abrenneke/jj-vine/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "jj-vine";
    maintainers = with lib.maintainers; [ winter ];
  };
})
