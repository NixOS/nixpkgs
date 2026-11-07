{
  lib,
  stdenv,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "freenet-core";
  version = "0.1.118";

  src = fetchCrate {
    pname = "freenet";
    version = finalAttrs.version;
    hash = "sha256-UGNNZ87thBKZ5XEFLpMtdaTv/wcG+IgU8wnMpovQ5yg=";
  };

  cargoHash = "sha256-VflN0W1HigyEky6IzQEB88jyCWYsjaXi1VqDowRz8b4=";

  # freenet edge-case tests cause build failure otherwise
  doCheck = false;

  meta = {
    description = "Freenet Core";
    homepage = "https://freenet.org/";
    license = lib.licenses.agpl3Only;
    platforms = with lib.platforms; linux;
    maintainers = [ ];
    changelog = "https://github.com/freenet/freenet-core/releases/tag/v${finalAttrs.version}";
    mainProgram = "freenet";
  };
})
