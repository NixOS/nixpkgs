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
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "moor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vnK/Lo/CK39gsX2FyXoB0Q7FpJ5+5AZrpVxCBkuupOQ=";
  };

  vendorHash = "sha256-FNkXrmNV8Gj2gAJX9a3wXiJ36/9edQFMIc6eAR9AYRU=";

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
    ];
  };
})
