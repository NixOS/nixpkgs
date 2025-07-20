{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "fblog";
  version = "4.14.0";

  src = fetchFromGitHub {
    owner = "brocode";
    repo = "fblog";
    rev = "v${version}";
    hash = "sha256-ImuNl7ERM7auuGkPHJ93unrqgXRCUBLAuG8OyJXFqms=";
  };

  cargoHash = "sha256-vk07dOaKo500xgFBfgfLaWsjpaXxpvX/ETgGr5HHnNE=";

  meta = with lib; {
    description = "Small command-line JSON log viewer";
    mainProgram = "fblog";
    homepage = "https://github.com/brocode/fblog";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ figsoda ];
  };
}
