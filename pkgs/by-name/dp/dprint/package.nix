{
  lib,
  stdenv,
  fetchCrate,
  rustPlatform,
  installShellFiles,
  testers,
  nix-update-script,
  dprint,
}:

rustPlatform.buildRustPackage rec {
  pname = "dprint";
  version = "0.47.6";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-7tGzSFp7Dnu27L65mqFd7hzeFFDfe1xJ6cMul3hGyJs=";
  };

  cargoHash = "sha256-y3tV3X7YMOUGBn2hCmxsUUc9QQleKEioTIw7SGoBvSQ=";

  # Tests fail because they expect a test WASM plugin. Tests already run for
  # every commit upstream on GitHub Actions
  doCheck = false;

  nativeBuildInputs = lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    export DPRINT_CACHE_DIR="$(mktemp -d)"
    installShellCompletion --cmd dprint \
      --bash <($out/bin/dprint completions bash) \
      --zsh <($out/bin/dprint completions zsh) \
      --fish <($out/bin/dprint completions fish)
  '';

  passthru = {
    tests.version = testers.testVersion {
      inherit version;

      package = dprint;
      command = ''
        DPRINT_CACHE_DIR="$(mktemp --directory)" dprint --version
      '';
    };

    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Code formatting platform written in Rust";
    longDescription = ''
      dprint is a pluggable and configurable code formatting platform written in Rust.
      It offers multiple WASM plugins to support various languages. It's written in
      Rust, so it’s small, fast, and portable.
    '';
    changelog = "https://github.com/dprint/dprint/releases/tag/${version}";
    homepage = "https://dprint.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ khushraj ];
    mainProgram = "dprint";
  };
}
