{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  nix,
  rustPlatform,
  installShellFiles,
}:
let
  version = "0.4.52";
in
rustPlatform.buildRustPackage rec {
  inherit version;
  pname = "mdbook";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "mdBook";
    tag = "v${version}";
    hash = "sha256-a3GSMz1+8Ve5cp4x1NjBlsCU/wMC4Jl3/H9qx7+1XlI=";
  };

  cargoHash = "sha256-wvTixSVHXglJM+nBMulZNZKF8pZfNd2G8Z+1PlAWmpk=";

  patches = [
    (fetchpatch2 {
      name = "fix-rust-1.91-tests.patch";
      url = "https://github.com/rust-lang/mdBook/commit/841c68d05e763b031524a2b4d679f033cd15e64c.patch?full_index=1";
      hash = "sha256-KDQhmFX2TWamtdyssFL69MP3vg9LABb+bF8/7vaFsew=";
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
    license = [ lib.licenses.mpl20 ];
    maintainers = with lib.maintainers; [
      Frostman
      matthiasbeyer
    ];
  };
}
