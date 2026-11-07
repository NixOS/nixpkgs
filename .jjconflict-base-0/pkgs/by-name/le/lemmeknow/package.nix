{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lemmeknow";
  version = "0.8.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-Q82tP4xNWAooFjHeJCFmuULnWlFbgca/9Y2lm8rVXKs=";
  };

  cargoHash = "sha256-65PPIYfwVO8O4K8yr499vRQScpAREiBZ8O0rrDMCXB8=";

  meta = {
    description = "Tool to identify anything";
    homepage = "https://github.com/swanandx/lemmeknow";
    changelog = "https://github.com/swanandx/lemmeknow/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "lemmeknow";
  };
})
