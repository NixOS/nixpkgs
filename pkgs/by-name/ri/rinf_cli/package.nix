{
  lib,
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage (finalAttrs: rec {
  pname = "rinf_cli";
  version = "8.7.2";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-IUeo8B6cjJRvOomTbr9NX6JVeQrO0aRlmLaYDivUqJE=";
  };

  cargoHash = "sha256-iqTXEab38UUQuNVQmEiRNZHjLxhXk1rIA1ih9U5beHo=";

  meta = {
    mainProgram = "rinf";
    description = "Framework for creating cross-platform Rust apps leveraging Flutter";
    homepage = "https://rinf.cunarist.com";
    changelog = "https://github.com/cunarist/rinf/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ noah765 ];
  };
})
