{
  lib,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rmux";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "Helvesec";
    repo = "rmux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dp0faMC2v8mArWE9EEeGggnm/vM3zXn7INXMcwaQZ5M=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-YMA42V2Wk4GeCDQsWZkWbOL1a74AzB+radfCkUZCuZ8=";

  nativeBuildInputs = [ installShellFiles ];

  passthru.updateScript = nix-update-script { };

  # Tests require network access
  doCheck = false;

  meta = {
    description = "Universal multiplexer with a typed SDK";
    homepage = "https://github.com/Helvesec/rmux";
    changelog = "https://github.com/Helvesec/rmux/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "rmux";
  };
})
