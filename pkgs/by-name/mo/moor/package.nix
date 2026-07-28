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
  version = "2.15.1";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "moor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AaoEG7N6N1OmJFlDRW1GhonKEQBaYKKYax/ahdEhtnU=";
  };

  vendorHash = "sha256-vf0hdrNy8HrQBtZZKwmbWOVn2TB6tV4qdews8Enjwao=";

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
