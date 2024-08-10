{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  darwin,
  rust-jemalloc-sys,
  nix-update-script,
  testers,
  sqruff,
}:
rustPlatform.buildRustPackage rec {
  pname = "sqruff";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "quarylabs";
    repo = "sqruff";
    rev = "refs/tags/v${version}";
    hash = "sha256-uUtbVf4U59jne5uORXpyzpqhFQoviKi2O9KQ5s1CfhU=";
  };

  cargoHash = "sha256-kIBjPh+rL4vzIAqGNYMpw39A0vADbHxi/PkhoG+QL6c=";

  # Requires nightly features (feature(let_chains) and feature(trait_upcasting))
  RUSTC_BOOTSTRAP = true;

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [
    rust-jemalloc-sys
  ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.CoreServices ];

  # Patch the tests to find the binary
  postPatch = ''
    substituteInPlace crates/cli/tests/ui.rs \
      --replace-fail \
      'config.program.program = format!("../../target/{profile}/sqruff").into();' \
      'config.program.program = "../../target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/sqruff".into();'
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = sqruff; };
  };

  meta = {
    description = "Fast SQL formatter/linter";
    homepage = "https://github.com/quarylabs/sqruff";
    changelog = "https://github.com/quarylabs/sqruff/releases/tag/${version}";
    license = lib.licenses.asl20;
    mainProgram = "sqruff";
    maintainers = with lib.maintainers; [ hasnep ];
  };
}
