{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  libiconv,
  useMimalloc ? false,
  doCheck ? true,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-analyzer-unwrapped";
  version = "2025-05-12";
  useFetchCargoVendor = true;
  cargoHash = "sha256-Y6/1xr08KXj+KQVJgLO7LhwsNGE2ooFdTR9GoAgAwKk=";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "rust-analyzer";
    rev = version;
    hash = "sha256-h3LQYZgyv2l3U7r+mcsrEOGRldaK0zJFwAAva4hV/6g=";
  };

  cargoBuildFlags = [
    "--bin"
    "rust-analyzer"
    "--bin"
    "rust-analyzer-proc-macro-srv"
  ];
  cargoTestFlags = [
    "--package"
    "rust-analyzer"
    "--package"
    "proc-macro-srv-cli"
  ];

  # Code format check requires more dependencies but don't really matter for packaging.
  # So just ignore it.
  checkFlags = [ "--skip=tidy::check_code_formatting" ];

  nativeBuildInputs = lib.optional useMimalloc cmake;

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  buildFeatures = lib.optional useMimalloc "mimalloc";

  env.CFG_RELEASE = version;

  inherit doCheck;
  preCheck = lib.optionalString doCheck ''
    export RUST_SRC_PATH=${rustPlatform.rustLibSrc}
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    versionOutput="$($out/bin/rust-analyzer --version)"
    echo "'rust-analyzer --version' returns: $versionOutput"
    [[ "$versionOutput" == "rust-analyzer ${version}" ]]
    runHook postInstallCheck
  '';

  passthru = {
    updateScript = nix-update-script { };
    # FIXME: Pass overrided `rust-analyzer` once `buildRustPackage` also implements #119942
    # FIXME: test script can't find rust std lib so hover doesn't return expected result
    # https://github.com/NixOS/nixpkgs/pull/354304
    # tests.neovim-lsp = callPackage ./test-neovim-lsp.nix { };
  };

  meta = with lib; {
    description = "Modular compiler frontend for the Rust language";
    homepage = "https://rust-analyzer.github.io";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [ oxalica ];
    mainProgram = "rust-analyzer";
  };
}
