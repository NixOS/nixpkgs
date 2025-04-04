{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
}:
rustPlatform.buildRustPackage rec {
  pname = "atac";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "Julien-cpsn";
    repo = "ATAC";
    rev = "v${version}";
    hash = "sha256-7y4DDoGguHfU4JxnMyRmjrqJ4gg76C9WSmZ8ey+Mitg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-sohEi3ARZlkNTQTpPVpQ1j/IyVP4rbBSdo6cpJdY1I4=";

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
