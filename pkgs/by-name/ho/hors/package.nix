{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "hors";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "windsoilder";
    repo = "hors";
    rev = "v${version}";
    sha256 = "1q17i8zg7dwd8al42wfnkn891dy5hdhw4325plnihkarr50avbr0";
  };

  cargoHash = "sha256-JTHgOEBpGXPO3C7YUbBF0LFeSUQK+R2w1LugwMV5xyU=";

  # requires network access
  doCheck = false;

  meta = {
    description = "Instant coding answers via the command line";
    mainProgram = "hors";
    homepage = "https://github.com/windsoilder/hors";
    changelog = "https://github.com/WindSoilder/hors/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ figsoda ];
  };
}
