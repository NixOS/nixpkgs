{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  pkg-config,
  perl,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "release-plz";
  version = "0.3.155";

  src = fetchFromGitHub {
    owner = "MarcoIeni";
    repo = "release-plz";
    rev = "release-plz-v${finalAttrs.version}";
    hash = "sha256-rgi/qh9tZlJFIHc01RRvUFD4sRWOTX1ScD2FwjAhL14=";
  };

  cargoHash = "sha256-VkQeNIvc6Ms1qBuqMfTQSr9p6yl3rYtWJbw4b9WaVEg=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    perl
  ];

  buildInputs = [ openssl ];

  buildAndTestSubdir = "crates/release_plz";

  # Tests depend on additional infrastructure to be running locally
  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${finalAttrs.meta.mainProgram} \
      --bash <($out/bin/${finalAttrs.meta.mainProgram} generate-completions bash) \
      --fish <($out/bin/${finalAttrs.meta.mainProgram} generate-completions fish) \
      --zsh <($out/bin/${finalAttrs.meta.mainProgram} generate-completions zsh)
  '';

  meta = {
    description = "Publish Rust crates from CI with a Release PR";
    homepage = "https://release-plz.ieni.dev";
    changelog = "https://github.com/MarcoIeni/release-plz/blob/release-plz-v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      dannixon
      chrjabs
    ];
    mainProgram = "release-plz";
    broken = stdenv.hostPlatform.isDarwin;
  };
})
