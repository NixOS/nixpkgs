{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-feature";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "Riey";
    repo = "cargo-feature";
    rev = "v${version}";
    sha256 = "sha256-UPpqkz/PwoMaJan9itfldjyTmZmiMb6PzCyu9Vtjj1s=";
  };

  cargoHash = "sha256-leciPTXFQ/O/KISBz4BV5KYIdld4UmiFE2yR8MoUVu0=";

  checkFlags = [
    # The following tests require empty CARGO_BUILD_TARGET env variable, but we
    # set it ever since https://github.com/NixOS/nixpkgs/pull/298108.
    "--skip=add_target_feature"
    "--skip=list_optional_deps_as_feature"
  ];

<<<<<<< HEAD
  meta = {
    description = "Cargo plugin to manage dependency features";
    mainProgram = "cargo-feature";
    homepage = "https://github.com/Riey/cargo-feature";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Cargo plugin to manage dependency features";
    mainProgram = "cargo-feature";
    homepage = "https://github.com/Riey/cargo-feature";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      riey
      matthiasbeyer
    ];
  };
}
