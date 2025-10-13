{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "cargo-unfmt";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "fprasx";
    repo = "cargo-unfmt";
    rev = "0f4882f65d248e32812e0e854fa11d7db60921e7";
    hash = "sha256-nvn4nZkkNQQvzShwoxtFqHeyhXQPm2GJoTKBI+MkFgM=";
  };

  cargoHash = "sha256-23mroUZFF4tPV92NhPlauGgTwLXsoxtE+Paqj5zsp7Q=";

  # Doc tests are broken on 0.3.3
  doCheck = false;

  meta = with lib; {
    description = "Unformat code into perfect rectangles";
    homepage = "https://github.com/fprasx/cargo-unfmt";
    license = licenses.gpl3Plus;
    mainProgram = "cargo-unfmt";
    maintainers = with maintainers; [ cafkafk ];
  };
}
