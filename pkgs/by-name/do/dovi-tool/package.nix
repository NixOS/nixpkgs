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
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "quietvoid";
    repo = "dovi_tool";
    tag = finalAttrs.version;
    hash = "sha256-CsF/KgY4D2pBXYzm6FtJt2xo7mSLt3JGkvajRYA4MWA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-21tb45F66yR5rquWML22EAPsExOkmas6Yquq9vEmhdk=";

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
