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
  buildAndTestSubdir = "goldboot";

  useFetchCargoVendor = true;
  cargoHash = "sha256-NF0Fj+r6qWcM4VEIm1fzveZuz6MIaG32Z+zBfSMC/t4=";
  doInstallCheck = true;
  nativeInstallCheck = [ versionCheckHook ];

  meta = {
    mainProgram = "goldboot";
    description = "Immutable infrastructure for the desktop!";
    homepage = "https://github.com/fossable/goldboot";
    changelog = "https://github.com/fossable/goldboot/releases/tag/goldboot-v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ cilki ];
  };
})
