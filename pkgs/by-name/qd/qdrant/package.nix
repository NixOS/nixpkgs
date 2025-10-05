{
  lib,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
  pkg-config,
  openssl,
  rust-jemalloc-sys,
  rust-jemalloc-sys-unprefixed,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "qdrant";
  version = "1.15.4";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "qdrant";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t+j7gq0PidvBGkjkyU8Zny9bgjKGNITUJOmyFnneZVY=";
  };

  cargoHash = "sha256-bcPSHoUOUliAU+GersU4auzdUiv9PPuAjrPO/FxovB8=";

  nativeBuildInputs = [
    protobuf
    rustPlatform.bindgenHook
    pkg-config
  ];

  buildInputs = [
    openssl
    rust-jemalloc-sys
    rust-jemalloc-sys-unprefixed
  ];

  # Needed to get openssl-sys to use pkg-config.
  env.OPENSSL_NO_VENDOR = 1;

  # Fix cargo-auditable issue with bench_rocksdb = ["dep:rocksdb"]
  auditable = false;

  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Vector Search Engine for the next generation of AI applications";
    longDescription = ''
      Expects a config file at config/config.yaml with content similar to
      https://github.com/qdrant/qdrant/blob/master/config/config.yaml
    '';
    homepage = "https://github.com/qdrant/qdrant";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dit7ya ];
  };
})
