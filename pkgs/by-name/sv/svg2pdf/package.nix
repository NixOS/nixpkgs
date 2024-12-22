{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "svg2pdf";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "typst";
    repo = "svg2pdf";
    rev = "v${version}";
    hash = "sha256-9v4A0mZjknc6a933b3ifPJo3xyem17Vpp0Wu0sUS0DM=";
  };

  cargoHash = "sha256-oCyvssTtUr8FR0XaFx2syxE8+zWXOGrf8kvQiBCyq18=";

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
      figsoda
    ];
    mainProgram = "svg2pdf";
  };
}
