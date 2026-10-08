{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "inherd-quake";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "phodal";
    repo = "quake";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-HKAR4LJm0lrQgTOCqtYIRFbO3qHtPbr4Fpx2ek1oJ4Q=";
  };

  cargoHash = "sha256-klxigm3RpTfwbENva2WmOPaiJEV2yujY323xRkAML0I=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ];

  meta = {
    description = "Knowledge management meta-framework for geeks";
    homepage = "https://github.com/phodal/quake";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.elliot ];
    mainProgram = "quake";
  };
})
