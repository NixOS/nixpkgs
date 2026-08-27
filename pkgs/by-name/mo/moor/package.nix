{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  pkgsCross,
  versionCheckHook,
}:

buildGo127Module (finalAttrs: {
  pname = "moor";
  version = "2.18.0";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "moor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lIkeMoGWWaBw/23/ATHC6uuZ0o7JCrzPQlmnoQT/lhg=";
  };

  vendorHash = "sha256-01FIkLojyCvjMjW4qe6mPP63hz5rYeVATyL0dW+F/Ek=";

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
      getchoo
      zowoq
    ];
  };
})
