{
  lib,
  fetchgit,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "revpfw3";
  version = "0.4.0";

  src = fetchgit {
    url = "https://git.tudbut.de/tudbut/revpfw3";
    rev = "v${version}";
    hash = "sha256-v8BtgQYdELui5Yu8kpE5f97MSo/WhNah+e1xXhZGJwM=";
  };

  cargoHash = "sha256-0AVp6fQq/NCkvKcK5ALbFNxNkt0NgbOmGlmDBGxwONQ=";

  meta = {
    description = "Reverse proxy to bypass the need for port forwarding";
    homepage = "https://git.tudbut.de/tudbut/revpfw3";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tudbut ];
    mainProgram = "revpfw3";
  };
}
