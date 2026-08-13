{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdbook-yml-header";
  version = "0.1.5";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-QlclxqH6cKo9QZyUBFCcujT9liTc8lmEheyjFKK7N58=";
  };

  cargoHash = "sha256-iBvVes32G0Ji9gk97axeTzbXlVh0Qn9Bzj64G6oEDFM=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MdBook preprocessor for removing yml header within --- (front-matter)";
    homepage = "https://github.com/dvogt23/mdbook-yml-header";
    license = lib.licenses.mpl20;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "mdbook-yml-header";
    maintainers = [ lib.maintainers.pinage404 ];
  };
})
