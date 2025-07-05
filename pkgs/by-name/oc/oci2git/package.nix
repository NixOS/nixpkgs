{
  fetchFromGitHub,
  lib,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oci2git";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Virviil";
    repo = "oci2git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+y2sWYoEuGGOYBk3E1b+2G9eF0mGSABHi92cCm+v590=";
  };

  cargoHash = "sha256-khl56908go19CV2XlwzH5xE4BNzQW8U7D6ce9OZgovA=";

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
    description = "Introspecting Docker images as easy as using Git";
    homepage = "https://github.com/Virviil/oci2git";
    changelog = "https://github.com/Virviil/oci2git/releases/tag/v${finalAttrs.version}";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.kpbaks ];
    mainProgram = "oci2git";
    platforms = lib.platforms.all;
  };
})
