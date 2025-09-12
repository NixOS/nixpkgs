{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
}:
rustPlatform.buildRustPackage rec {
  pname = "atac";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "Julien-cpsn";
    repo = "ATAC";
    rev = "v${version}";
    hash = "sha256-NTdz7NtjvVQolSiqyCdR0P4dD0+ZQBKMEXTzwHPZgxU=";
  };

  cargoHash = "sha256-iLExF4lwXQ1BVBxEK+iD5HDkbjk38AbLaIirS04C4iw=";

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
