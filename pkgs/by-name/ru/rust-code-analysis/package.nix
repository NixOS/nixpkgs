{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-code-analysis";
  version = "0.0.25";

  src = fetchCrate {
    pname = "rust-code-analysis-cli";
    inherit version;
    hash = "sha256-/Irmtsy1PdRWQ7dTAHLZJ9M0J7oi2IiJyW6HeTIDOCs=";
  };

  cargoHash = "sha256-HirLjKkfZfc9UmUcUF5WW7xAJuCu7ftJDH8+zTSYlxs=";

  meta = with lib; {
    description = "Analyze and collect metrics on source code";
    homepage = "https://github.com/mozilla/rust-code-analysis";
    license = with licenses; [
      mit # grammars
      mpl20 # code
    ];
    maintainers = [ ];
    mainProgram = "rust-code-analysis-cli";
  };
}
