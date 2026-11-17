{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "packsquash";
  version = "0.4.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    repo = "PackSquash";
    owner = "ComunidadAylas";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c2nVG9qjla3E5O5oD57+KxYh21Iu+fL1LFNC+rw6QR0=";
  };

  cargoHash = "sha256-dx2Cm2zNr9FARd1fc6ehynxrA1qHwtQQGMmEbGuc0dk=";

  env = {
    # Requires nightly toolchain for feature(core_intrinsics)
    RUSTC_BOOTSTRAP = 1;
    # if_let_guard is stable since Rust 1.95.0, but some deps still carry
    # the stale #![feature(if_let_guard)] attribute.
    RUSTFLAGS = "-A stable-features";
  };

  nativeBuildInputs = [ cmake ];

  # Fails in sandbox
  checkFlags = [
    "--skip=squash_zip::system_id::tests"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Resource and data pack optimizer for Minecraft: Java Edition";
    homepage = "https://packsquash.aylas.org/";
    changelog = "https://github.com/ComunidadAylas/PackSquash/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "packsquash";
  };
})
