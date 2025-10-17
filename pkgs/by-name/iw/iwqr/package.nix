{
  lib,
  rustPlatform,
  fetchFromGitea,
  nix-update-script,
  testers,
  iwqr,
}:

rustPlatform.buildRustPackage rec {
  pname = "iwqr";
  version = "0.1.1";

  src = fetchFromGitea {
    domain = "git.kroner.dev";
    owner = "kreny";
    repo = "iwqr";
    rev = "v${version}";
    hash = "sha256-z9CjCJvi6MlZGghZKx13gGSKwUnECAf0cr9P2ABskh0=";
  };

  cargoHash = "sha256-wnthAp/oV6W7G/a5JXYwzni+qGzDiVefIjRamkJ5jQc=";

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = iwqr;
    };
  };

  meta = with lib; {
    description = "Tool for generating qr codes for iwd networks";
    homepage = "https://git.kroner.dev/kreny/iwqr";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ h7x4 ];
    mainProgram = "iwqr";
  };
}
