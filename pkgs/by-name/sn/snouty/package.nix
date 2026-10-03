{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  openssl,
  writableTmpDirAsHomeHook,
  podman,
  docker-compose,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "snouty";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "antithesishq";
    repo = "snouty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ob9Z20V7r126nFYsXnPaE1DFcmtbEYJjSlrrGucWpqg=";
  };

  cargoPatches = [
    # merges snouty's Cargo.lock contents with hegeltest-c's Cargo.lock contents
    ./hegeltest-c-deps.patch
  ];

  cargoHash = "sha256-EYVYpWS+Lg4CKDiYkypzAM080wdOBC09i+m3FD2lYTU=";

  postPatch = ''
    # the current rust setup hook leaves this unsubstituted file around unnecessarily
    # but it makes hegeltest-c be unable to find the vendored deps
    rm "$cargoDepsCopy"/.cargo/config.toml
  '';

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  env.OPENSSL_NO_VENDOR = true;

  postInstall = lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    installShellCompletion --cmd snouty \
      --bash <($out/bin/snouty completions bash) \
      --zsh <($out/bin/snouty completions zsh) \
      --fish <($out/bin/snouty completions fish)
  '';

  useNextest = true;

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    podman
    docker-compose
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for the Antithesis API";
    homepage = "https://github.com/antithesishq/snouty";
    changelog = "https://github.com/antithesishq/snouty/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      carlsverre
      winter
    ];
    mainProgram = "snouty";
  };
})
