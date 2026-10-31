{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "pdfsink-rs";
  version = "0.2.18";

  src = fetchFromGitHub {
    owner = "clark-labs-inc";
    repo = "pdfsink-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y0XdnL8n/WHWr2tbSP8NSdnZ57Ei0l8EAPfCFabhbk8=";
  };

  cargoHash = "sha256-U/KdjykbfThRZMPogjzEpGKcIndnvTDK/YOD5MnQBqI=";

  meta = {
    description = "Fast pure-Rust PDF extraction library";
    homepage = "https://github.com/clark-labs-inc/pdfsink-rs";
    changelog = "https://github.com/clark-labs-inc/pdfsink-rs/releases/tag/v${finalAttrs.version}";
    mainProgram = "pdfsink-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ trespaul ];
  };
})
