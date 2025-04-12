{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "csv2svg";
  version = "0.1.9";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-3VebLFkeJLK97jqoPXt4Wt6QTR0Zyu+eQV9oaLBSeHE=";
  };

  cargoHash = "sha256-EIsKb9BzM+H3BO7OpoTmvIvGd578gYSq5vU18BejT0s=";

  meta = with lib; {
    description = "Take a csv as input and outputs svg";
    homepage = "https://github.com/Canop/csv2svg";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "csv2svg";
  };
}
