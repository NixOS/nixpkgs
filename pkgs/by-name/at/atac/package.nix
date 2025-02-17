{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
}:
rustPlatform.buildRustPackage rec {
  pname = "atac";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "Julien-cpsn";
    repo = "ATAC";
    rev = "v${version}";
    hash = "sha256-RrtRflMTsbR/A2kb2kdwsE7zN43TzzvFkUPcmL4YGqs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-NxTWJ7uMblEIpumJhVCCek9UzJuqJeTrt5fLXYiITI4=";

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
