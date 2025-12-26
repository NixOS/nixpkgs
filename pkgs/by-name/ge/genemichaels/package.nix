{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "genemichaels";
  version = "0.9.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-dXmIijGAcXuwtU9WbmuN1rAv7hY9Ah2JbGXAgPxq9k4=";
  };

  cargoHash = "sha256-+eIUNblWdR+OA27NCtT+rueh5EcwvTr3CGf80Cn/r+4=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Even formats macros";
    homepage = "https://github.com/andrewbaxter/genemichaels";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ djacu ];
    mainProgram = "genemichaels";
  };
}
