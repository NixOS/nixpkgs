{
  lib,
  buildGo123Module,
  fetchFromGitHub,
}:
buildGo123Module rec {
  pname = "nak";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "fiatjaf";
    repo = "nak";
    rev = "refs/tags/v${version}";
    hash = "sha256-VUSBCvDW53Z+mdAx0bUQIgcsiEwxOnm/FnnMcSC0iks=";
  };

  vendorHash = "sha256-alex1YEkviR5O0KLGZlOsf1i7s6m1C4LxHdJCogDCng=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  # Integration tests fail (requires connection to relays)
  doCheck = false;

  meta = {
    description = "Command-line tool for Nostr things";
    homepage = "https://github.com/fiatjaf/nak";
    changelog = "https://github.com/fiatjaf/nak/releases/tag/${version}";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "nak";
  };
}
