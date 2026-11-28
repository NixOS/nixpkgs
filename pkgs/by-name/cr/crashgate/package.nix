{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "crashgate";
  version = "0.1.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "wjkoh";
    repo = "crashgate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NYxdTHR/IYNMS7R9YpEBYhRDEhCFlUPRhLU/EQRlrDs=";
  };

  vendorHash = null;

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Read-only deep-crash margin and tax-loss harvest watchdog for hledger";
    homepage = "https://github.com/wjkoh/crashgate";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wjkoh ];
    mainProgram = "crashgate";
  };
})
