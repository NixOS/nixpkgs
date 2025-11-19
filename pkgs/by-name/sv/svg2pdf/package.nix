{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "svg2pdf";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "typst";
    repo = "svg2pdf";
    rev = "v${version}";
    hash = "sha256-A3lUX2q5D1Z5Q3sZOl2uvaOLTuLRdtJyR9tmfPkE7TI=";
  };

  cargoHash = "sha256-Fr4UC12WpJiIkLKcxk9D7AdBD+VSyS4NQVfqn/p6NqM=";

  cargoBuildFlags = [
    "-p=svg2pdf-cli"
  ];

  meta = with lib; {
    description = "Convert SVG files to PDFs";
    homepage = "https://github.com/typst/svg2pdf";
    changelog = "https://github.com/typst/svg2pdf/releases/tag/${src.rev}";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [
      doronbehar
    ];
    mainProgram = "svg2pdf";
  };
}
