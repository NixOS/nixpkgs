{
  lib,
  rustPlatform,
  fetchFromGitHub,
  librime,
  rime-data,
}:
rustPlatform.buildRustPackage rec {
  pname = "rime-ls";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "wlh320";
    repo = "rime-ls";
    rev = "v${version}";
    hash = "sha256-jDn41hSDcQQO1d4G0XV6B/JZkryHtuoHUOYpmdE1Kxo=";
  };

  cargoHash = "sha256-lmvIH6ssEqbkcDETzHL+Spd04B576o8dijigUR88l9c=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  buildInputs = [ librime ];

  # Set RIME_DATA_DIR to work around test_get_candidates during checkPhase
  env.RIME_DATA_DIR = "${rime-data}/share/rime-data";

  meta = {
    description = "Language server for Rime input method engine";
    homepage = "https://github.com/wlh320/rime-ls";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ definfo ];
    mainProgram = "rime_ls";
  };
}
