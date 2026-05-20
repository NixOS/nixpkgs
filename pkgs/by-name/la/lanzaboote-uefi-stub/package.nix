{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lanzaboote-uefi-stub";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "lanzaboote";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RJmgVDzjRI18BWVogG6wpsl1UCuV6ui8qr4DJ1LfWZ8=";
  };

  sourceRoot = "${finalAttrs.src.name}/rust/uefi";
  cargoHash = "sha256-DQ8vnw81fW+uK1va53XTNvhoHBJv07JURumCvGGeBzQ=";

  # Necessary because our `cc-wrapper` doesn't understand MSVC link options.
  # -flavor link which will break the whole command-line processing for the ld.lld linker.
  RUSTFLAGS = "-C linker=${stdenv.cc.bintools}/bin/${stdenv.cc.targetPrefix}ld.lld -C linker-flavor=lld-link";
  # Does not support MSVC style options yet (?).
  auditable = false;
  hardeningDisable = [
    "relro"
    "bindnow"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lanzaboote UEFI stub for SecureBoot enablement on NixOS systems";
    homepage = "https://github.com/nix-community/lanzaboote";
    license = lib.licenses.gpl3Only;
    mainProgram = "lanzaboote_stub.efi";
    maintainers = with lib.maintainers; [
      raitobezarius
      ThinkChaos
    ];
    platforms = [
      "x86_64-uefi"
    ];
  };
})
