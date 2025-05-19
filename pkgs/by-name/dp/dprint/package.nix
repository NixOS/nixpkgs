{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  testers,
  nix-update-script,
  dprint,
}:

rustPlatform.buildRustPackage rec {
  pname = "dprint";
  version = "0.50.0";

  # Prefer repository rather than crate here
  #   - They have Cargo.lock in the repository
  #   - They have WASM files in the repository which will be used in checkPhase
  src = fetchFromGitHub {
    owner = "dprint";
    repo = "dprint";
    tag = version;
    hash = "sha256-6AgbKH5f7N/yYqq7KBVHOqYbyuZkjFSaYwZwIXsgd9o=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-OnrsuVK1gEDweldq+P8lDkkrHjklsG8MRpM0wqWsdlM=";

  nativeBuildInputs = lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    installShellFiles
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
    maintainers = with maintainers; [
      khushraj
      kachick
      phanirithvij
    ];
    mainProgram = "dprint";
  };
}
