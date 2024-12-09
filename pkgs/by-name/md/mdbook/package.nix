{
  lib,
  stdenv,
  fetchFromGitHub,
  nix,
  rustPlatform,
  darwin,
  CoreServices ? darwin.apple_sdk.frameworks.CoreServices,
  installShellFiles,
}:
let
  version = "0.4.40";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "mdbook";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "mdBook";
    rev = "refs/tags/v${version}";
    hash = "sha256-GGQK2Mf3EK1rwBMzQkAzWAaK6Fh0Qqqf8dtDjZPxOMA=";
  };

  cargoHash = "sha256-jriSQHn+Y+EWtwDJeMTAuCCHR7fEtWsErAxbG9a4pts=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ CoreServices ];

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
    license = [ lib.licenses.mpl20 ];
    maintainers = with lib.maintainers; [
      havvy
      Frostman
      matthiasbeyer
    ];
  };
}
