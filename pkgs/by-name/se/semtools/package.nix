{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  openssl,
  pkg-config,
  protobuf,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "semtools";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "run-llama";
    repo = "semtools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m5QK4i1oa0ytjJEqhSn7WFqqYo4JPb/4jr4Cde4MNQs=";
  };

  cargoHash = "sha256-pMR9KPkLCtkngMwnEB2reXvsl9kUghaQFD0YL4yqDi0=";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];
  buildInputs = [ openssl ];

  checkFlags = lib.optionals (stdenv.hostPlatform.system == "x86_64-darwin") [
    # https://github.com/run-llama/semtools/issues/17
    "--skip=tests::test_search_result_context_calculation"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Semantic search and document parsing tools for the command line";
    homepage = "https://github.com/run-llama/semtools";
    changelog = "https://github.com/run-llama/semtools/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.amadejkastelic ];
  };
})
