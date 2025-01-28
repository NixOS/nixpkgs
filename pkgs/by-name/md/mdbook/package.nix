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
  version = "0.4.43";
in
rustPlatform.buildRustPackage rec {
  inherit version;
  pname = "mdbook";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "mdBook";
    tag = "v${version}";
    hash = "sha256-aADNcuIeDef9+a3NOWQxo6IRnKJ6AbkvE4GqvFbubyI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    allowGitDependencies = false;
    hash = "sha256-W5hg6ECNQRIh07ogZkXTn51el2YltutY86aJBYFDTP4=";
  };

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
