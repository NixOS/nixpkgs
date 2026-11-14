{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  aws-lc,
  zstd,
  pkg-config,
  protobuf,
  versionCheckHook,
  nix-update-script,
  installShellFiles,
  buildPackages,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "moon";
  version = "2.6.5";

  src = fetchFromGitHub {
    owner = "moonrepo";
    repo = "moon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8hFkMycHklfFZEdEzqxAt63ajQ8Wk5dusC65bpiNxbw=";
  };

  cargoHash = "sha256-UqyfHdHN4i7Cuw1bN2BH8mQh3TAdl4JN9pP4q2EiNcQ=";

  env = {
    RUSTFLAGS = "-C strip=symbols";
    OPENSSL_NO_VENDOR = 1;
  };

  buildInputs = [
    openssl
    aws-lc
    zstd
  ];
  nativeBuildInputs = [
    pkg-config
    protobuf
    installShellFiles
    writableTmpDirAsHomeHook
  ];

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd moon \
        --bash <(${emulator} $out/bin/moon completions --shell bash) \
        --fish <(${emulator} $out/bin/moon completions --shell fish) \
        --zsh <(${emulator} $out/bin/moon completions --shell zsh)
    ''
  );

  # Some tests fail, because test using internet connection and install NodeJS by example
  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Task runner and repo management tool for the web ecosystem, written in Rust";
    mainProgram = "moon";
    homepage = "https://github.com/moonrepo/moon";
    changelog = "https://github.com/moonrepo/moon/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      flemzord
      flupke
      maxence-lefebvre
    ];
  };
})
