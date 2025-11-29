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

  checkFlags =
    let
      skippedTests = [
        # failing subtly
        "tests::html::rust_reference_regression_nested_elements"
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
