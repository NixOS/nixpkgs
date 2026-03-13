{
  lib,
  callPackage,
  fetchFromGitHub,
  stdenv,
  makeWrapper,
  pandoc,
  rustPlatform,
  texliveSmall,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-pandoc";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "max-heller";
    repo = "mdbook-pandoc";
    tag = "v${version}";
    hash = "sha256-lLuw6CZPWHZ8DZz/lWTd+eEv688HcbkvsxLRvW38RKs=";
  };

  cargoHash = "sha256-TMFnF/aTJ2UrtnPZ4UOQke6dtUZbUxywf4JIX53mhKY=";

  nativeBuildInputs = [ makeWrapper ];

  nativeCheckInputs = [
    pandoc
    # some tests require pdflatex
    texliveSmall
  ];

  passthru = {
    wrapper = callPackage ./wrapper.nix { };
  };

  meta = {
    homepage = "https://github.com/max-heller/mdbook-pandoc";
    description = "A mdbook backend powered by Pandoc";
    changelog = "https://github.com/max-heller/mdbook-pandoc/releases/tag/${src.tag}";
    license = with lib.licenses; [
      asl20
      # or
      mit
    ];
    maintainers = with lib.maintainers; [
      astro
    ];
  };
}
