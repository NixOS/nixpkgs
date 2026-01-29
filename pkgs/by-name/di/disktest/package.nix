{
  fetchFromGitHub,
  rustPlatform,
  lib,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "disktest";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "mbuesch";
    repo = "disktest";
    tag = "disktest-${finalAttrs.version}";
    hash = "sha256-j6L5K0AfUeleU9Igjf8BqzhClETk6nuXr4WXVl5rMzg=";
  };

  cargoHash = "sha256-B2RbK990HYEC2fSF5rb7VMEQokdOmkgkZXcvUlQjfY4=";

  buildAndTestSubdir = "disktest";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "disktest";
    description = "Solid State Disk (SSD), USB Stick, SD-Card, Hard Disk (HDD) tester";
    homepage = "https://github.com/mbuesch/disktest";
    license = [
      lib.licenses.mit # or
      lib.licenses.asl20
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ cilki ];
  };
})
