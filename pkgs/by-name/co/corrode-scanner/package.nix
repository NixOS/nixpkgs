{
  lib,
  aws-lc,
  pkg-config,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "corrode-scanner";
  version = "0.5.4";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ul0gic";
    repo = "corrode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OMMDD/J1V33DpaNGJooiiCmbU+W11JweGs7fsb0XgR4=";
  };

  cargoHash = "sha256-Pqs/hB2N59W8aiy/btWL1KQ68JPrczLXYX1deI4mdR0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ aws-lc ];

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
