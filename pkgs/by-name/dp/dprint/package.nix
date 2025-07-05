{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  buildPackages,
  installShellFiles,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dprint";
  version = "0.50.0";

  # Prefer repository rather than crate here
  #   - They have Cargo.lock in the repository
  #   - They have WASM files in the repository which will be used in checkPhase
  src = fetchFromGitHub {
    owner = "dprint";
    repo = "dprint";
    tag = finalAttrs.version;
    hash = "sha256-6AgbKH5f7N/yYqq7KBVHOqYbyuZkjFSaYwZwIXsgd9o=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-OnrsuVK1gEDweldq+P8lDkkrHjklsG8MRpM0wqWsdlM=";

  nativeBuildInputs = [ installShellFiles ];

  cargoBuildFlags = [
    "--package=dprint"
    # Required only for dprint package tests; the binary is removed in postInstall.
    "--package=test-process-plugin"
  ];

  cargoTestFlags = [
    "--package=dprint"
  ];

  checkFlags = [
    # Require creating directory and network access
    "--skip=plugins::cache_fs_locks::test"
    "--skip=utils::lax_single_process_fs_flag::test"
    # Require cargo is running
    "--skip=utils::process::test"
    # Requires deno for the testing, and making unstable results on darwin
    "--skip=utils::url::test::unsafe_ignore_cert"
  ];

  postInstall =
    let
      dprint =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out/bin/dprint"
        else
          lib.getExe buildPackages.dprint;
    in
    ''
      rm "$out/bin/test-process-plugin"
      export DPRINT_CACHE_DIR="$(mktemp -d)"
      installShellCompletion --cmd dprint \
        --bash <(${dprint} completions bash) \
        --zsh <(${dprint} completions zsh) \
        --fish <(${dprint} completions fish)
    '';

  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/dprint";
  versionCheckProgramArg = "--version";
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Code formatting platform written in Rust";
    longDescription = ''
      dprint is a pluggable and configurable code formatting platform written in Rust.
      It offers multiple WASM plugins to support various languages. It's written in
      Rust, so it’s small, fast, and portable.
    '';
    changelog = "https://github.com/dprint/dprint/releases/tag/${finalAttrs.version}";
    homepage = "https://dprint.dev";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      khushraj
      kachick
      phanirithvij
    ];
    mainProgram = "dprint";
  };
})
