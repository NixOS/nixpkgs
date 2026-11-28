{
  lib,
  rustPlatform,
  fetchCrate,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "starlark-rust";
  version = "0.14.2";

  src = fetchCrate {
    pname = "starlark_bin";
    inherit (finalAttrs) version;
    hash = "sha256-2Fqy/ZyL45NasK5iMuJVG+2J7HUQ7UlXNfdKuuCKnJk=";
  };

  cargoHash = "sha256-FYzDYs/c/7T4RHnSqOImOIoS1uxXZpfOcUrrP3tMJFY=";

  buildInputs = [ sqlite ];

  meta = {
    description = "Rust implementation of the Starlark language";
    homepage = "https://github.com/facebook/starlark-rust";
    changelog = "https://github.com/facebook/starlark-rust/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "starlark";
  };
})
