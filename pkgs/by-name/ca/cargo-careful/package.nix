{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-careful";
<<<<<<< HEAD
  version = "0.4.9";
=======
  version = "0.4.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "RalfJung";
    repo = "cargo-careful";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-huo5KFb+qoPVHNrnR+vb97iNinGaU5d3NbFhAgGCzCk=";
  };

  cargoHash = "sha256-mjGUSwqyqgnGwKjznj8KedIzOJi4GDldJEL0fzpuvec=";

  meta = {
    description = "Tool to execute Rust code carefully, with extra checking along the way";
    mainProgram = "cargo-careful";
    homepage = "https://github.com/RalfJung/cargo-careful";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
=======
    hash = "sha256-KT0sYftintyaFKr+thnK+SV36Gt9BQZL/9j+u9DtzRM=";
  };

  cargoHash = "sha256-oLMUGbhN9/6U6mcjxJTLxqogwDaXWhf/gW10l37wNdY=";

  meta = with lib; {
    description = "Tool to execute Rust code carefully, with extra checking along the way";
    mainProgram = "cargo-careful";
    homepage = "https://github.com/RalfJung/cargo-careful";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      matthiasbeyer
    ];
  };
}
