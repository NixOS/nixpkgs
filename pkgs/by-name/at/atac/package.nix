{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
}:
rustPlatform.buildRustPackage rec {
  pname = "atac";
  version = "0.18.2";

  src = fetchFromGitHub {
    owner = "Julien-cpsn";
    repo = "ATAC";
    rev = "v${version}";
    hash = "sha256-4lURe1DPgtoWToVdoXKQFYEbp5/1tmogx4u/4PLBluE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-hM3c0O0IfZYycdGJu65ov2B5KkV3nhbRg5dzO4LxX3M=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ oniguruma ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  meta = with lib; {
    description = "Simple API client (postman like) in your terminal";
    homepage = "https://github.com/Julien-cpsn/ATAC";
    license = licenses.mit;
    maintainers = with maintainers; [ vinnymeller ];
    mainProgram = "atac";
  };
}
