{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "redu";
  version = "0.2.12";

  src = fetchFromGitHub {
    owner = "drdo";
    repo = "redu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3DcBTpog5tWv2qdmhOlDLHFY77Cug6mCpDQEAtViw74=";
  };

  cargoHash = "sha256-Rp8y2tBnpzBVEoLP4fTMulIJpu1j2TpJNh5M9kjnuEo=";

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
