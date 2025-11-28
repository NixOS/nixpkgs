{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "mpris-notifier";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "l1na-forever";
    repo = "mpris-notifier";
    rev = "v${version}";
    hash = "sha256-JDABuxINYxpxxDPSIdN+GeHU8FqBS6m4dsPDTxRc1Zw=";
  };

  cargoHash = "sha256-lM3co7akhLoFarprbnqladSzK+OkysduEe6uXpAoCwU=";

  meta = with lib; {
    description = "Dependency-light, highly-customizable, XDG desktop notification generator for MPRIS status changes";
    homepage = "https://github.com/l1na-forever/mpris-notifier";
    license = licenses.mit;
    maintainers = with maintainers; [ leixb ];
    mainProgram = "mpris-notifier";
  };
}
