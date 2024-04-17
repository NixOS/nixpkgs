{ lib
, rustPlatform
, fetchFromGitLab
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "spade";
  version = "0.7.0";

  src = fetchFromGitLab {
    owner = "spade-lang";
    repo = "spade";
    rev = "v${version}";
    hash = "sha256-oJfOgWobjt+DAVdP465E8iLMJCdqhs0vzJJFgRqVAP8=";
    # only needed for vatch, which contains test data
    fetchSubmodules = true;
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "codespan-0.12.0" = "sha256-3F2006BR3hyhxcUTaQiOjzTEuRECKJKjIDyXonS/lrE=";
      "tracing-tree-0.2.0" = "sha256-/JNeAKjAXmKPh0et8958yS7joORDbid9dhFB0VUAhZc=";
    };
  };

  meta = with lib; {
    description = "A better hardware description language";
    homepage = "https://gitlab.com/spade-lang/spade";
    changelog = "https://gitlab.com/spade-lang/spade/-/blob/${src.rev}/CHANGELOG.md";
    # compiler is eupl12, spade-lang stdlib is both asl20 and mit
    license = with licenses; [ eupl12 asl20 mit ];
    maintainers = with maintainers; [ pbsds ];
    mainProgram = "spade";
    broken = stdenv.isDarwin; # ld: symbol(s) not found for architecture ${system}
  };
}
