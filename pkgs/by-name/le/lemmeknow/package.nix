{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "lemmeknow";
  version = "0.8.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Q82tP4xNWAooFjHeJCFmuULnWlFbgca/9Y2lm8rVXKs=";
  };

  cargoHash = "sha256-65PPIYfwVO8O4K8yr499vRQScpAREiBZ8O0rrDMCXB8=";

  meta = {
    description = "Tool to identify anything";
    homepage = "https://github.com/swanandx/lemmeknow";
    changelog = "https://github.com/swanandx/lemmeknow/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Br1ght0ne
    ];
    mainProgram = "lemmeknow";
  };
}
