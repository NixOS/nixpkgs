{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "semtools";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "run-llama";
    repo = "semtools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wpOKEESM3uG9m/EqWnF2uXITbrwIhwe2MSA0FN7Fu+w=";
  };

  cargoHash = "sha256-irLhwlNnB3G63WUGV2wo+LQGQgNHYzu/vb/RM/G6Fdc=";

  nativeBuildInputs = [ pkg-config ];
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
