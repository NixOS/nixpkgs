{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  nix,
  rustPlatform,
  installShellFiles,
}:
let
  version = "0.5.4";
in
rustPlatform.buildRustPackage rec {
  inherit version;
  pname = "mdbook";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "mdBook";
    tag = "v${version}";
    hash = "sha256-1bUMFxPpb9H/pRdCOX0u8Tn8RPmJElDs7o9t5JtRFuU=";
  };

  cargoHash = "sha256-OmlcPZuQ1RbyFrF5tuztucgtCA544UHJxEaXh/mfSHQ=";

  patches = [
    # fix tests which assert on output when compiling with rust 1.100
    (fetchpatch {
      name = "rust-1.100-cargo-clippy-lints.patch";
      url = "https://github.com/rust-lang/mdBook/commit/7a8d704ab8b82fdc28c8d0bd97aa814c58b5d985.patch";
      hash = "sha256-od6TIOEUrEECGlPldbck1sriU17TjgPwlZJ1ZRukc8c=";
    })
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd mdbook \
      --bash <($out/bin/mdbook completions bash) \
      --fish <($out/bin/mdbook completions fish) \
      --zsh  <($out/bin/mdbook completions zsh )
  '';

  passthru = {
    tests = {
      inherit nix;
    };
  };

  meta = {
    description = "Create books from MarkDown";
    mainProgram = "mdbook";
    homepage = "https://github.com/rust-lang/mdBook";
    changelog = "https://github.com/rust-lang/mdBook/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      Frostman
      matthiasbeyer
    ];
  };
}
