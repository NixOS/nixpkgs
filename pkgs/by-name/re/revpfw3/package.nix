{
  lib,
  fetchgit,
  rustPlatform,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "revpfw3";
  version = "0.4.3";

  passthru.updateScript = nix-update-script { };

  src = fetchgit {
    url = "https://git.tudbut.de/tudbut/revpfw3";
    rev = "v${version}";
    hash = "sha256-7MnYTY/7PWu+VvxABtSLUnJ4FPzd9QCfrUBcSxcXUso=";
  };

  cargoHash = "sha256-D+9269WRCvpohyhrl6wkzalV7wPsJE38hSviTU2CNyg=";

  meta = {
    description = "Reverse proxy to bypass the need for port forwarding";
    homepage = "https://git.tudbut.de/tudbut/revpfw3";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tudbut ];
    mainProgram = "revpfw3";
  };
}
