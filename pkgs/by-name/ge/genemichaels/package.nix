{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "genemichaels";
  version = "0.12.2";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-KZ0XHPeOGM1Go/144fAbfaXgj1h7Kuu/H8H3a/bf1+w=";
  };

  cargoHash = "sha256-hLEFEqt4M+7H6y0oINiAhDv9Y/ifknnP8FNz7ROJA3w=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Even formats macros";
    homepage = "https://github.com/andrewbaxter/genemichaels";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ djacu ];
    mainProgram = "genemichaels";
  };
})
