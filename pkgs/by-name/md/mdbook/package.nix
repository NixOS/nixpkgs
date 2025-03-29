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
  version = "0.4.47";
in
rustPlatform.buildRustPackage rec {
  inherit version;
  pname = "mdbook";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "mdBook";
    tag = "v${version}";
    hash = "sha256-XTvC2pGRVat0kOybNb9TziG32wDVexnFx2ahmpUFmaA=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    allowGitDependencies = false;
    hash = "sha256-ASPRBAB+elJuyXpPQBm3WI97wD3mjoO1hw0fNHc+KAw=";
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
