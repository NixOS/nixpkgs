{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "functiontrace-server";
  version = "0.8.7";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-ejwYax2L4737JjLrnPLIw7OhTft0lhJ9egRBYDhM53E=";
  };

  cargoHash = "sha256-YSZ2jRKsdi5DVnVQs7/XAp1BJpLEQ7o/2q9iH1ErT3s=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Server for FunctionTrace, a graphical Python profiler";
    homepage = "https://functiontrace.com";
    license = lib.licenses.prosperity30;
    maintainers = with lib.maintainers; [ tehmatt ];
  };
}
