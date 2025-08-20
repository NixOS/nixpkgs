{
  lib,
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-rinf-cli";
  version = "8.7.2";

  src = fetchCrate {
    inherit (finalAttrs) version;
    pname = "rinf_cli";
    hash = "sha256-IUeo8B6cjJRvOomTbr9NX6JVeQrO0aRlmLaYDivUqJE=";
  };

  cargoHash = "sha256-iqTXEab38UUQuNVQmEiRNZHjLxhXk1rIA1ih9U5beHo=";

  meta = {
    description = "Rust for native business logic, Flutter for flexible and beautiful GUI";
    mainProgram = "rinf";
    homepage = "https://github.com/cunarist/rinf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      shakhzodkudratov
    ];
  };
})
