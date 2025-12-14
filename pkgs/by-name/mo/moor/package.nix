{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  pkgsCross,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "moor";
  version = "2.9.5";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "moor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oyxDVhP2pzHqaDyGrKPNRGzvMH3Bwdi6tYYCjo+CweQ=";
  };

  vendorHash = "sha256-l1XeVZ4FyQDu2sKo4/SieBbwUicq3gNE3D/0m6fcGt8=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.versionString=v${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  postInstall = ''
    installManPage ./moor.1
  '';

  passthru = {
    tests.cross-aarch64 = pkgsCross.aarch64-multiplatform.moor;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Nice-to-use pager for humans";
    homepage = "https://github.com/walles/moor";
    changelog = "https://github.com/walles/moor/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2WithViews;
    mainProgram = "moor";
    maintainers = with lib.maintainers; [
      foo-dogsquared
      getchoo
      zowoq
    ];
  };
})
