{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "galerio";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "dbrgn";
    repo = "galerio";
    rev = "v${version}";
    hash = "sha256-JR/YfMUs5IHBRr3uYqHXLNcr23YHyDvgH2y/1ip+2Y8=";
  };

  cargoHash = "sha256-jXUAjK/fqBaXaehcbFZU02w9/MTHluqKjtWGoAJa7ks=";

<<<<<<< HEAD
  meta = {
    description = "Simple generator for self-contained HTML flexbox galleries";
    homepage = "https://github.com/dbrgn/galerio";
    maintainers = with lib.maintainers; [ dbrgn ];
    license = with lib.licenses; [
=======
  meta = with lib; {
    description = "Simple generator for self-contained HTML flexbox galleries";
    homepage = "https://github.com/dbrgn/galerio";
    maintainers = with maintainers; [ dbrgn ];
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      asl20
      mit
    ];
    mainProgram = "galerio";
  };
}
