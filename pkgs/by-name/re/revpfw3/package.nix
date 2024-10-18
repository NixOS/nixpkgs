{
  lib,
  fetchgit,
  rustPlatform,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "revpfw3";
  version = "0.4.2";

  passthru.updateScript = nix-update-script { };

  src = fetchgit {
    url = "https://git.tudbut.de/tudbut/revpfw3";
    rev = "v${version}";
    hash = "sha256-v8BtgQYdELui5Yu8kpE5f97MSo/WhNah+e1xXhZGJwM=";
  };

  cargoHash = "sha256-MmVN4NmwSZiWYh7uMAQ+OogJT1kRLoB2q6gVfoaer54=";

  meta = {
    description = "Reverse proxy to bypass the need for port forwarding";
    homepage = "https://git.tudbut.de/tudbut/revpfw3";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tudbut ];
    mainProgram = "revpfw3";
  };
}
