{
  lib,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rmux";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "Helvesec";
    repo = "rmux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jW8SM4X4py+NG4f4Fgc1hzPlscb9SMo/z6nduYNxQqg=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-5amM2awHwtBnvFlV7EJJyZtXEmPzeW/Gv89q6/z26dk=";

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
