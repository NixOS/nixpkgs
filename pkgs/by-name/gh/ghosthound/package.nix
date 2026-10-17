{
  lib,
  fetchFromGitHub,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ghosthound";
  version = "0.1.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "JVBotelho";
    repo = "ghosthound";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UI01b0oiIiH9dIQClgnagTqb6OJgvmhXqIifh1aelDM=";
  };

  cargoHash = "sha256-ut6qwKdLvQgL66G5PQ817QMBCMz72aWNHK7MLpz5ql0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "BloodHound OpenGraph extension that surfaces Active Directory";
    homepage = "https://github.com/JVBotelho/ghosthound";
    changelog = "https://github.com/JVBotelho/ghosthound/releases/tag/${finalAttrs.src.tag}";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "ghosthound";
  };
})
