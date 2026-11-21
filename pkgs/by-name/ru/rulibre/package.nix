{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "rulibre";
  version = "0.1.2";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-os/m2DMJ3+mb1ivs7J9M/O8oFdDNy2SBLHblylBlXKk=";
  };

  cargoHash = "sha256-EtbTOWywfi4MjJj6Z3DCSlF0HvSw2EU1s6r6v5nXFPE=";
  cargoDepsName = finalAttrs.pname;

  meta = {
    description = "A lightweight TUI replacement for Calibre's interface — browse your library and transfer books to your e-reader";
    homepage = "https://github.com/Glydric/Rulibre";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ utzuro ];
    mainProgram = "rulibre";
    platforms = lib.platforms.unix;
  };
})
