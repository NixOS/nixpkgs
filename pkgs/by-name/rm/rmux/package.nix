{
  lib,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rmux";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Helvesec";
    repo = "rmux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W4Jw2r+4x90+x5WkrRwxrlqytRlU4wEY98MWJZbcblY=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-fu96A2v5VH01HxNGpdLpBTH3o9DHrocSyvuK14nE1fk=";

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
