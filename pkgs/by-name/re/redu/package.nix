{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "redu";
  version = "0.2.14";

  src = fetchFromGitHub {
    owner = "drdo";
    repo = "redu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E5itus0l1eENVWaSXUQHumxfo0ZMfSsguJuVSw0Uauk=";
  };

  cargoHash = "sha256-ZUA9zmWzPvyFmqQFW3ShnQRqG3TODN7K8Ex1jrOZxd0=";

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
