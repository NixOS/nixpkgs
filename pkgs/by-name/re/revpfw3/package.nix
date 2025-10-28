{
  lib,
  fetchgit,
  rustPlatform,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "revpfw3";
  version = "0.5.0";

  passthru.updateScript = nix-update-script { };

  src = fetchgit {
    url = "https://git.tudbut.de/tudbut/revpfw3";
    rev = "v${version}";
    hash = "sha256-oqBzRpfL5sMxE29HwVXW4rdnf5cfNCn2pUqZiYDhHDk=";
  };

  cargoHash = "sha256-F9ngyKWAdm3GyN6cSErtHoMN/u6A3ML7OMFP1QIaH9c=";

  meta = {
    description = "Reverse proxy to bypass the need for port forwarding";
    homepage = "https://git.tudbut.de/tudbut/revpfw3";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tudbut ];
    mainProgram = "revpfw3";
  };
}
