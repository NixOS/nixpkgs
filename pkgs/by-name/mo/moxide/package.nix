{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "moxide";
  version = "0.2.0";

  useFetchCargoVendor = true;
  cargoHash = "sha256-nHp5KSU1mzsr3t8diREhs5fbxrJcJaEpciZNKCkmp5A=";
  src = fetchFromGitHub {
    owner = "dlurak";
    repo = "moxide";
    tag = "v${version}";
    hash = "sha256-f3suE8Gz7V62+O1J3W+Ps2HhVCAhRmxRFfrB2Lc1Tz4=";
  };

  meta = {
    description = "Tmux session manager with a modular configuration";
    mainProgram = "moxide";
    homepage = "https://github.com/dlurak/moxide";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dlurak ];
  };
}
