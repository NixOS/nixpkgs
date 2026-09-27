{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pqcscan";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "anvilsecure";
    repo = "pqcscan";
    tag = finalAttrs.version;
    hash = "sha256-+IwUESqmxvZu53n5ORNoYVD8JiSwAjD9AudnsXfIKvc=";
  };

  cargoHash = "sha256-ZZm1I4fsw4PDCVZYuyhy4fC5ocfz1Snrv9vMltF26x8=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  meta = {
    description = "Post-Quantum Cryptography Scanner";
    homepage = "https://github.com/anvilsecure/pqcscan";
    changelog = "https://github.com/anvilsecure/pqcscan/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pqcscan";
  };
})
