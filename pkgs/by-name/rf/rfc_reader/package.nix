{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rfc_reader";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "ozan2003";
    repo = "rfc_reader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Hm8BVIMxRlyiVptvuS8vk2eO3hHboj5CRefWcMEhzvs=";
  };

  cargoHash = "sha256-ro0BVMbShxo/EsPBOCBOgYDsOkDnxpyTZlk2eAJ2IWA=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI RFC viewer";
    homepage = "https://github.com/ozan2003/rfc_reader";
    changelog = "https://github.com/ozan2003/rfc_reader/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "rfc_reader";
  };
})
