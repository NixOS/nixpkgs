{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "fblog";
  version = "4.16.0";

  src = fetchFromGitHub {
    owner = "brocode";
    repo = "fblog";
    rev = "v${version}";
    hash = "sha256-SWwk7qNe2R1aBYGBFqltUZjeOvr4jG1P7/CPIAfHCc8=";
  };

  cargoHash = "sha256-du9FXuUNqQm1AMqcCFqeso5OPrPCxzTVl5e7kR0rpwc=";

  meta = with lib; {
    description = "Small command-line JSON log viewer";
    mainProgram = "fblog";
    homepage = "https://github.com/brocode/fblog";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ figsoda ];
  };
}
