{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "redu";
  version = "0.2.13";

  src = fetchFromGitHub {
    owner = "drdo";
    repo = "redu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iea3tt1WB0/5XPNeCAk38/UoCHVSngXfNmfZQyspmsw=";
  };

  cargoHash = "sha256-fiMZIFIVeFnBnRBgmdUB8E5A2pM5nrTfUgD1LS6a4LQ=";

  env.RUSTC_BOOTSTRAP = 1;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "ncdu for your restic repo";
    homepage = "https://github.com/drdo/redu";
    changelog = "https://github.com/drdo/redu/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alexfmpe ];
    mainProgram = "redu";
  };
})
