{
  lib,
  callPackage,
  fetchFromGitHub,
  makeWrapper,
  pandoc,
  rustPlatform,
  texliveSmall,
}:

let
  self = rustPlatform.buildRustPackage {
    pname = "mdbook-pandoc";
    version = "0.6.4";

    src = fetchFromGitHub {
      owner = "max-heller";
      repo = "mdbook-pandoc";
      rev= "v${self.version}";
      hash = "sha256-WaRcNfVfex9ujZ1fD8NhQ72phUh4WgyZtI3zuZ63Koc=";
    };

    cargoHash = "sha256-XT/YkR8kRJ30bCXmfxKQJQL7tPl+eAPr4jIhmStJ8TM=";

    nativeBuildInputs = [ makeWrapper ];

    nativeCheckInputs = [
      pandoc
      # some tests require pdflatex
      texliveSmall
    ];

    checkFlags = let
      skippedTests = [
      # require network access
      "remote_images"
      "cargo_book"
      "mdbook_guide"
      "nomicon"
      "rust_book"
      "rust_by_example"
      "rust_edition_guide"
      "rust_embedded"
      "rust_reference"
      "rustc_dev_guide"
      # failed because pandoc
      "code_block_with_very_long_line"
      "code_block_with_very_long_line_with_special_characters"
      ];
    in
      builtins.map (x: "--skip " + x) skippedTests;

    passthru = {
      wrapper = callPackage ./wrapper.nix { };
    };

    meta = {
      homepage = "https://github.com/max-heller/mdbook-pandoc";
      description = "A mdbook backend powered by Pandoc";
      changelog = "https://github.com/max-heller/mdbook-pandoc/releases/tag/${self.src.rev}";
      license = with lib.licenses; [
        asl20
        /* or */
        mit
      ];
      maintainers = with lib.maintainers; [ AndersonTorres ];
    };
  };
in
self
