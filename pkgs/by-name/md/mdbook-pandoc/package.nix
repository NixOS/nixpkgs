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

let
  self = rustPlatform.buildRustPackage {
    pname = "mdbook-pandoc";
    version = "0.10.5";

    src = fetchFromGitHub {
      owner = "max-heller";
      repo = "mdbook-pandoc";
      rev = "v${self.version}";
      hash = "sha256-ihKju9XXJy4JciuMLw4EcKhqSQjrBiUJDG0Rd5DbFdk=";
    };

    cargoHash = "sha256-SXXzGOBvfyLYhed5EMFUCzkFWoGEMM73PD3uWjkUcic=";

    nativeBuildInputs = [ makeWrapper ];

    nativeCheckInputs = [
      pandoc
      # some tests require pdflatex
      texliveSmall
    ];

    checkFlags =
      let
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
          "tests::css::css"
          "tests::definition_lists::dt_attributes"
          "tests::html::attach_id_to_div_of_stripped_html_elements"
          "tests::html::link_to_element_by_id"
          "tests::images::images"
        ]
        ++ lib.optional stdenv.buildPlatform.isDarwin "pandoc::tests::five_item_deep_list";
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
        # or
        mit
      ];
      maintainers = with lib.maintainers; [
        AndersonTorres
        astro
      ];
    };
  };
in
self
