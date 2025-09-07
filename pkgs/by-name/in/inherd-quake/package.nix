{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "inherd-quake";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "phodal";
    repo = "quake";
    rev = "v${version}";
    sha256 = "sha256-HKAR4LJm0lrQgTOCqtYIRFbO3qHtPbr4Fpx2ek1oJ4Q=";
  };

  cargoHash = "sha256-klxigm3RpTfwbENva2WmOPaiJEV2yujY323xRkAML0I=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ];

  meta = with lib; {
    description = "Knowledge management meta-framework for geeks";
    homepage = "https://github.com/phodal/quake";
    license = licenses.mit;
    maintainers = [ maintainers.elliot ];
    mainProgram = "quake";
  };
}
