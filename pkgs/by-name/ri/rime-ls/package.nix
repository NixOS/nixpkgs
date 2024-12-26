{
  lib,
  rustPlatform,
  fetchFromGitHub,
  librime,
  rime-data,
}:
rustPlatform.buildRustPackage rec {
  pname = "rime-ls";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "wlh320";
    repo = "rime-ls";
    rev = "v${version}";
    hash = "sha256-IhrfUPC+7Gsg2n6nsGiK/wRoFGKtLXsRLQBw6XIVu0U=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-beppHZXtNni8tLgZaC6CyL2HMBK7xy5/kP1jFr6JW+M=";

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
