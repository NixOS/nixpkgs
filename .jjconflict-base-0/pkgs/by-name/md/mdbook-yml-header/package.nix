{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:

let
  pname = "mdbook-yml-header";
  version = "0.1.4";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-qRAqZUKOiXTh4cJjczBQ9zAL6voaDvko7elfE6eB2jA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-C8M2Y7igeDmi337GXWmLcwNTGr1/CTHWWTuMPDtkqxs=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MdBook preprocessor for removing yml header within --- (front-matter)";
    homepage = "https://github.com/dvogt23/mdbook-yml-header";
    license = lib.licenses.mpl20;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "mdbook-yml-header";
    maintainers = [ lib.maintainers.pinage404 ];
  };
}
