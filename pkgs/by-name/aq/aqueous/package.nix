{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  zstd,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "aqueous";
  version = "0.0.20261031";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lifthrasiir";
    repo = "aqueous";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WfxVn7Gx4Unr8fACTZysiYexVM1IDgas+5avVloxPHs=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-mmPaTbhkbdPDKUQPUIqR6Bh/T+12y1s37ctmQSWGz5s=";

  cargoBuildFlags = [
    "--package"
    "aqr"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  checkFlags = [
    # restores a setuid bit, which the sandbox does not allow
    "--skip=metadata_kept"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    zstd
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Aqueous Archive Format";
    homepage = "https://github.com/lifthrasiir/aqueous";
    changelog = "https://github.com/lifthrasiir/aqueous/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit0;
    maintainers = with lib.maintainers; [ bglgwyng ];
    mainProgram = "aqr";
  };
})
