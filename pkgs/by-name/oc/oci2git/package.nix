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
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "Virviil";
    repo = "oci2git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vz4OqRg7CYliAswQWtzEWUb7Z10fwxDhYrvQ3q4ZtPA=";
  };

  cargoHash = "sha256-Aj93f+L4h1FxHpWehD11sTPXTFsg2B9rJ96mSJ/VVQ4=";

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
