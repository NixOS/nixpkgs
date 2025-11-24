{
  lib,
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "minhtml";
  version = "0.18.1";

  # Upstream does not include a lock file.
  # See https://github.com/wilsonzlin/minify-html/issues/255
  src = fetchCrate {
    pname = "minhtml";
    inherit (finalAttrs) version;
    hash = "sha256-yrZueueww9rQXaHCeBO6d2pO58SZ8yz2a9Ia5dp7lBY=";
  };

  cargoHash = "sha256-TFlDbVL8JARwV/xSQ+Cbwguqnr11nw24/L0MbHJazas=";

  meta = {
    description = "Minifier for HTML, JavaScript, and CSS";
    mainProgram = "minhtml";
    homepage = "https://github.com/wilsonzlin/minify-html";
    changelog = "https://github.com/wilsonzlin/minify-html/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tye-exe ];
  };
})
