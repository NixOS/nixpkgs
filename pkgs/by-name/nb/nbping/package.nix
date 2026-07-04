{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
let
  pname = "nbping";
  version = "0.7.1";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "hanshuaikang";
    repo = "Nping";
    tag = "v${version}";
    hash = "sha256-QaJTV5RNvsYuBUPrWcmbBj1QSKtfDNTvHd5fMfuoU3c=";
  };

  cargoHash = "sha256-H0FG3BE/iP3knosnUVzJtNXt8hQ9E8Jh/2MTmviNhfA=";

  meta = {
    description = "Ping Tool in Rust with Real-Time Data and Visualizations";
    homepage = "https://github.com/hanshuaikang/Nping";
    changelog = "https://github.com/hanshuaikang/Nping/releases/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "nbping";
  };
}
