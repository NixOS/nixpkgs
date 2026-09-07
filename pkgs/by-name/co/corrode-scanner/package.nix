{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "corrode-scanner";
  version = "0.5.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ul0gic";
    repo = "corrode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cxmX0UOEI78P9K4glTh7B2b+/Uc5pHY961RamarvZm0=";
  };

  cargoHash = "sha256-f+gwucHpQu5IJqll/DmGYkNwu/5a2esl9URpwj7c3Pc=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Security scanner for finding exposed credentials, secrets, and vulnerabilities";
    homepage = "https://github.com/ul0gic/corrode";
    changelog = "https://github.com/ul0gic/corrode/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "corrode-scanner";
  };
})
