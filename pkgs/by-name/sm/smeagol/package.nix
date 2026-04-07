{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "smeagol";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "AustinWise";
    repo = "smeagol";
    tag = finalAttrs.version;
    hash = "sha256-9TjYiVqz+Lxp0VaeQB3p/wpeRWbMFCJLGnQPMGafSyc=";
  };

  cargoHash = "sha256-cd8PotJPNdwpXKpuHbMQ4aJeNewDhyRvctAHimVdLS8=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/smeagol-wiki";

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
