{ lib
, fetchFromGitHub
, rustPlatform
, pandoc
, texliveSmall
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-pandoc";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "max-heller";
    repo = "mdbook-pandoc";
    rev= "v${version}";
    hash = "sha256-lsgvpS7OoIwANERWnPcBEqYvZAKKsrPoufJOXbXxOkg=";
  };

  cargoHash = "sha256-oBS2QWQJM4QrYJz37+mldAxI5XOVYMuOKqNiRgAGICs=";

  postPatch = ''
    for pandocUser in src/{pandoc.rs,pandoc/renderer.rs}; do
      substituteInPlace $pandocUser \
        --replace-fail 'Command::new("pandoc")' 'Command::new("${pandoc}/bin/pandoc")'
    done
  '';

  nativeCheckInputs = [ texliveSmall ];

  checkFlags = [
    "--skip remote_images"
    "--skip cargo_book"
    "--skip mdbook_guide"
    "--skip nomicon"
    "--skip rust_book"
    "--skip rust_by_example"
    "--skip rust_edition_guide"
    "--skip rust_embedded"
    "--skip rust_reference"
    "--skip rustc_dev_guide"
  ];

  meta = with lib; {
    description = "A mdbook backend powered by Pandoc.";
    homepage = "https://github.com/max-heller/mdbook-pandoc";
    license = [ licenses.asl20 /* or */ licenses.mit ];
    maintainers = with maintainers; [ liketechnik ];
  };
}
