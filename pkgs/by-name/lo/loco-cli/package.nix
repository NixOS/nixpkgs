{
  lib,
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage rec {
  pname = "loco-cli";
  version = "0.12.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-4wEgPnkNEPM9Qi7SG/iw8xjhHs7esdwYs7dMGdAZ18c=";
  };

  cargoHash = "sha256-Ww+DL+XbtEe2vdY7RqNePwQWRP5BSLyuhjwSg7uO0dI=";

  #Skip trycmd integration tests
  checkFlags = [ "--skip=cli_tests" ];

  meta = {
    description = "Loco CLI is a powerful command-line tool designed to streamline the process of generating Loco websites";
    homepage = "https://loco.rs";
    changelog = "https://github.com/loco-rs/loco/blob/master/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sebrut ];
    mainProgram = "loco";
  };
}
