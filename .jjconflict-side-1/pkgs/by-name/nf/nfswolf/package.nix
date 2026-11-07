{
  lib,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nfswolf";
  version = "1.2.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "StrongWind1";
    repo = "NFSWolf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E46Q9tLMuhPbt51MYnK1VcgjVi2v0LoYwC0iUZXoOTk=";
  };

  cargoHash = "sha256-PfAw8gTRA8HJcNzJczFgDahhgHJ2bCFguTPR+OqzZ2g=";

  nativeBuildInputs = [ pkg-config ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "NFS security toolkit";
    homepage = "https://github.com/StrongWind1/NFSWolf";
    changelog = "https://github.com/StrongWind1/NFSWolf/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "nfswolf";
  };
})
