{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "okolors";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "Ivordir";
    repo = "Okolors";
    rev = "v${version}";
    sha256 = "sha256-Cwe6kyhsCU3wbuD0PTnj1JQOnMjH+sLmG5AiJImRGSU=";
  };

  cargoSha256 = "sha256-RVUrgz/YddT41N1omoPCW3Cjz7IWjc8sB7OwkCUDjM8=";

  meta = with lib; {
    description = "Generate a color palette from an image using k-means clustering in the Oklab color space";
    homepage = "https://github.com/Ivordir/Okolors";
    license = licenses.mit;
    maintainers = with maintainers; [ laurent-f1z1 ];
    mainProgram = "okolors";
  };
}
