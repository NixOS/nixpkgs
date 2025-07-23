{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
}:
rustPlatform.buildRustPackage rec {
  pname = "atac";
  version = "0.20.2";

  src = fetchFromGitHub {
    owner = "Julien-cpsn";
    repo = "ATAC";
    rev = "v${version}";
    hash = "sha256-m+2D1Vrh6Qi7iDOCuio76p7d4eAkjuCSZXxJD9spPrw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-W94oaBgws5FUF2Xax+O7faiQgfhcyTeGoCu+VJD0Wd0=";

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
