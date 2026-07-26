{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  sqlite,
  gitMinimal,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rtk";
  version = "0.44.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rtk-ai";
    repo = "rtk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ev6w0Gi2y48DYi55GSciCoPgkUFaX44aH3UWGhs1OGk=";
  };

  cargoHash = "sha256-x+6bZZh0s3YPgav7S/4VrYxZBWAlX1BmvCFJHLmIjGM=";

  # Rust 1.97's dead_code_pub_in_binary analysis exposes dead code in test builds.
  # Fixed upstream on develop after 0.44.0:
  # https://github.com/rtk-ai/rtk/commit/73b8cb3069297374a3de58552b9fe4aa2cda3a41
  # TODO: Remove RUSTFLAGS when updating rtk to the next release.
  env.RUSTFLAGS = "--cap-lints warn";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    sqlite
  ];

  postInstall = ''
    wrapProgram $out/bin/rtk \
      --prefix PATH : ${
        lib.makeBinPath [
          gitMinimal
        ]
      }
  '';

  nativeCheckInputs = [
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "CLI proxy that reduces LLM token consumption by 60-90% on common dev commands";
    homepage = "https://github.com/rtk-ai/rtk";
    changelog = "https://github.com/rtk-ai/rtk/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "rtk";
  };
})
