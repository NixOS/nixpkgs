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
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "max-heller";
    repo = "mdbook-pandoc";
    tag = "v${version}";
    hash = "sha256-Br+rt8OrAvLIRKlNyKJd97wb0/ZlQoBRCfGU1haxNa4=";
  };

  cargoHash = "sha256-pzRwxIEWVAJxa6tmjvalD/lFyK86vAmv78nAhp6X104=";

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
