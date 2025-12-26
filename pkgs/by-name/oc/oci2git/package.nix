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
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "Virviil";
    repo = "oci2git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-83Rcw4K3+bqcvqoXTQ2ay/7eAO6GT76RV3qFzfX6O60=";
  };

  cargoHash = "sha256-7OallIrRg278Bo9iV7FStXbZ1W29RuAK6AnB3PQNWrY=";

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
