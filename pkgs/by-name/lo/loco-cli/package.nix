{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "loco-cli";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "loco-rs";
    repo = "loco";
    rev = "51e0362";
    hash = "sha256-ZiAl+Ru2ggLy7RRqQySwKRbWtGesR7ZgREIpHKrJ00Q=";
    sparseCheckout = [ "loco-cli" ];
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  sourceRoot = "${src.name}/loco-cli";

  meta = with lib; {
    mainProgram = "loco";
    description = "Loco CLI is a powerful command-line tool designed to streamline the process of generating Loco websites";
    homepage = "https://loco.rs";
    changelog = "https://github.com/loco-rs/loco/blob/master/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ sebrut ];
  };
}
