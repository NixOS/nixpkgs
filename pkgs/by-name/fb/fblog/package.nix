{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "fblog";
  version = "4.13.1";

  src = fetchFromGitHub {
    owner = "brocode";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-YOHLw8YCgOGB1Nn2tD+EnicKd/tiMk07OWv+49btbpw=";
  };

  cargoHash = "sha256-+rhrvZ8EOYAFSvAvGyUwlDCWXVqgXPdmugBbrn12yLg=";

  meta = with lib; {
    description = "Small command-line JSON log viewer";
    mainProgram = "fblog";
    homepage = "https://github.com/brocode/fblog";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ figsoda ];
  };
}
