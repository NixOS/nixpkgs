{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  fontconfig,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dovi-tool";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "quietvoid";
    repo = "dovi_tool";
    tag = finalAttrs.version;
    hash = "sha256-4C9d8Rt1meV6Pcdnf2SaiWGA97sRj2WmvKsf1rC01Bs=";
  };

  cargoHash = "sha256-Dg6IDcYm3qTSyE5kVgZ8Yka8538KDFyBN+weUyAfQT8=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    fontconfig
  ];

  checkFlags = [
    # fails because nix-store is read only
    "--skip=rpu::plot::plot_p7"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/dovi_tool";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool combining multiple utilities for working with Dolby Vision";
    homepage = "https://github.com/quietvoid/dovi_tool";
    changelog = "https://github.com/quietvoid/dovi_tool/releases/tag/${finalAttrs.version}";
    mainProgram = "dovi_tool";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ plamper ];
  };
})
