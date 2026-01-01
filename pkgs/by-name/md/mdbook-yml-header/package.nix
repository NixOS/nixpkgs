{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:

let
  pname = "mdbook-yml-header";
<<<<<<< HEAD
  version = "0.1.5";
=======
  version = "0.1.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchCrate {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-QlclxqH6cKo9QZyUBFCcujT9liTc8lmEheyjFKK7N58=";
  };

  cargoHash = "sha256-iBvVes32G0Ji9gk97axeTzbXlVh0Qn9Bzj64G6oEDFM=";
=======
    hash = "sha256-qRAqZUKOiXTh4cJjczBQ9zAL6voaDvko7elfE6eB2jA=";
  };

  cargoHash = "sha256-C8M2Y7igeDmi337GXWmLcwNTGr1/CTHWWTuMPDtkqxs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
