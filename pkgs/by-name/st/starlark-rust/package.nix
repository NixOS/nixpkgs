{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "starlark-rust";
  version = "0.14.0";

  src = fetchCrate {
    pname = "starlark_bin";
    inherit (finalAttrs) version;
    hash = "sha256-uNhMtBpfkTQdWNyjklP6NC3aXwXqH23PN4MWOjaR49w=";
  };

  cargoHash = "sha256-1x0QESkxze/MP7/E0whPwx3zSv+JC2OH7pz5adO1JFk=";

  meta = {
    description = "Rust implementation of the Starlark language";
    homepage = "https://github.com/facebook/starlark-rust";
    changelog = "https://github.com/facebook/starlark-rust/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "starlark";
  };
})
