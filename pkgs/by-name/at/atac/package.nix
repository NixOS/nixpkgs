{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
}:
rustPlatform.buildRustPackage rec {
  pname = "atac";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "Julien-cpsn";
    repo = "ATAC";
    rev = "v${version}";
    hash = "sha256-PXSjyMe7Rcoeczm/cqFgn1Ra66T9cA34NdfaqLTljmc=";
  };

  cargoHash = "sha256-qjg5yxWRcNnmrl91kogUEOfFOs06tcgmK2hpqx6nftU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ oniguruma ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

<<<<<<< HEAD
  meta = {
    description = "Simple API client (postman like) in your terminal";
    homepage = "https://github.com/Julien-cpsn/ATAC";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vinnymeller ];
=======
  meta = with lib; {
    description = "Simple API client (postman like) in your terminal";
    homepage = "https://github.com/Julien-cpsn/ATAC";
    license = licenses.mit;
    maintainers = with maintainers; [ vinnymeller ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "atac";
  };
}
