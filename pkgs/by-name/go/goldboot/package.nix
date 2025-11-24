{
  fetchFromGitHub,
  rustPlatform,
  lib,
  versionCheckHook,
  pkg-config,
  zstd,
  OVMF,
  qemu,
  qemu-utils,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "goldboot";
  version = "0.0.10";

  src = fetchFromGitHub {
    owner = "fossable";
    repo = "goldboot";
    rev = "goldboot-v${finalAttrs.version}";
    hash = "sha256-O9yhyJZpjQxC0HP43RsOgPMOKp6d23SNhMLiGtmwXzs=";
  };

  cargoHash = "sha256-NF0Fj+r6qWcM4VEIm1fzveZuz6MIaG32Z+zBfSMC/t4=";

  buildAndTestSubdir = "goldboot";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    zstd
    OVMF
    qemu
    qemu-utils
    openssl
  ];

  # Tests require networking, so skip them for now
  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "goldboot";
    description = "Immutable infrastructure for the desktop";
    homepage = "https://github.com/fossable/goldboot";
    changelog = "https://github.com/fossable/goldboot/releases/tag/goldboot-v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ cilki ];
  };
})
