{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "functiontrace-server";
  version = "0.8.6";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-f/DpT5IYhUA/+w+QK3Itk4bBaYRFhGOWQbN51YYrmxA=";
  };

  cargoHash = "sha256-rDCIzJUFA+2iEpITg3MuKFfgiyQ6GtMvIigiHkX70M8=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Server for FunctionTrace, a graphical Python profiler";
    homepage = "https://functiontrace.com";
    license = with lib.licenses; [ prosperity30 ];
    maintainers = with lib.maintainers; [ tehmatt ];
  };
}
