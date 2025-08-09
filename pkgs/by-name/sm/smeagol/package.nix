{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "smeagol";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "AustinWise";
    repo = "smeagol";
    tag = finalAttrs.version;
    hash = "sha256-ILZ4TRL5yRGZuyyNPIpMgnlBGQAwbtTFlTaN3UYb5ls=";
  };

  cargoHash = "sha256-5OSrxm+NpuimE8Jwl5/VScKjuYNROX50KNiyBMZqCOw=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/smeagol-wiki";
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Locally hosted wiki";
    homepage = "https://smeagol.dev/";
    changelog = "https://github.com/AustinWise/smeagol/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "smeagol-wiki";
  };
})
