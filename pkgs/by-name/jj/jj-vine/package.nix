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
  version = "0.3.6";

  src = fetchFromCodeberg {
    owner = "abrenneke";
    repo = "jj-vine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vvNbeQvP205snAGiql/i8yFGyMw23YkSU4/uxOSnycY=";
  };

  cargoHash = "sha256-vcpaKlNeORnDpVqXxu0TrXWaWNfaK9QPVJOrty9WmcQ=";

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
