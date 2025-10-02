{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "SVGCleaner";
  version = "unstable-2021-08-30";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = "SVGCleaner";
    rev = "575eac74400a5ac45c912b144f0c002aa4a0135f";
    sha256 = "sha256-pRDRRVb8Lyna8X/PEjS9tS5dbG4g7vyMCU5AqPlpxec=";
  };

  cargoHash = "sha256-5HRhKW1VbecUdc+iad3hOKsR82JI2Pgtio3z/8pqZIg=";

  meta = with lib; {
    description = "Clean and optimize SVG files from unnecessary data";
    homepage = "https://github.com/RazrFalcon/SVGCleaner";
    changelog = "https://github.com/RazrFalcon/svgcleaner/releases";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    mainProgram = "svgcleaner";
  };
}
