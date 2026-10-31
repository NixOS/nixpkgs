{
  fetchFromGitHub,
  rustPlatform,
  lib,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "disktest";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "mbuesch";
    repo = "disktest";
    tag = "disktest-${finalAttrs.version}";
    hash = "sha256-PjY0m56OjXGHEVMIvEJhlhPebCcehQNcyrYhjgRqmQ8=";
  };

  cargoHash = "sha256-TSzvmvAE3iurb4LGvoiibYim+qOOvOo8UJZjRHtFsnU=";

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
