{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "breakrs";
  version = "0.2.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-SvE3EMboc1ifLsXcMTltliULaiJwiO5IgQDthhJSWYU=";
  };

  cargoHash = "sha256-AFv+9Xb/18/wbIp5QcutBkP57mn3/Pdk9rlFkGk8EZc=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple, ergonomic cli to generate timed notifications";
    homepage = "https://github.com/sqrew/breakrs";
    changelog = "https://github.com/sqrew/breakrs/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.hollymlem ];
    mainProgram = "breakrs";
  };
})
