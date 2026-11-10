{
  lib,
  rustPlatform,
  fetchFromGitHub,
  kclvm,
  rustc,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kclvm_cli";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "kcl-lang";
    repo = "kcl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wRmLXR1r/FtZVfc6jifEj0jS0U0HIgJzBtuuzLQchjo=";
  };

  sourceRoot = "${finalAttrs.src.name}/cli";

  cargoHash = "sha256-ZhrjxHqwWwcVkCVkJJnVm2CZLfRlrI2383ejgI+B2KQ=";
  cargoPatches = [ ./cargo_lock.patch ];

  buildInputs = [
    kclvm
    rustc
  ];

  meta = {
    description = "High-performance implementation of KCL written in Rust that uses LLVM as the compiler backend";
    homepage = "https://github.com/kcl-lang/kcl";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      selfuryon
    ];
    mainProgram = "kclvm_cli";
  };
})
