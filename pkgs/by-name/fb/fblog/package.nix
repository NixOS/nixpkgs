{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "fblog";
  version = "4.15.0";

  src = fetchFromGitHub {
    owner = "brocode";
    repo = "fblog";
    rev = "v${version}";
    hash = "sha256-IPT/1k8bs2NBbq5KthvcJY7eBwbnFop8cO0OiLgRZg4=";
  };

  cargoHash = "sha256-puZN1ao+Grw9nWQvNfqAwmY9Lb6+z13EPv/cZlueYxc=";

  meta = with lib; {
    description = "Small command-line JSON log viewer";
    mainProgram = "fblog";
    homepage = "https://github.com/brocode/fblog";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ figsoda ];
  };
}
