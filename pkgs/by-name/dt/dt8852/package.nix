{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dt8852";
  version = "0.9.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "drupol";
    repo = "dt8852";
    tag = finalAttrs.version;
    hash = "sha256-MjV1otIOQa5r6/JRaV+wdxFgP9zbcCjqqAW5vowN82U=";
  };

  cargoHash = "sha256-9ZnNDXlkWvi06Q/HtV/mFq4posHu5ALOnZHYboh4GTo=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    udev
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Driver and command-line tool for the CEM DT-8852 sound level meter";
    homepage = "https://github.com/drupol/dt8852";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "dt8852";
  };
})
