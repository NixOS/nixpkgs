{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  pkg-config,
  perl,
  openssl,
  curl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "release-plz";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "release-plz";
    repo = "release-plz";
    rev = "release-plz-v${finalAttrs.version}";
    hash = "sha256-DcjWGKs9PUmTojeDUZkvtAMTroSlBL6lNZwOJT8VsiY=";
  };

  cargoHash = "sha256-GYQ+GC0eZ6EzugwyEcZMwt9SZ0aYlQr2BFfUjjyqiB4=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    perl
  ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ curl ];

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
    changelog = "https://github.com/release-plz/release-plz/blob/release-plz-v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      dannixon
      chrjabs
    ];
    mainProgram = "release-plz";
  };
})
