{
  fetchCrate,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "clini";
  version = "0.1.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-+HnoYFRG7GGef5lV4CUsUzqPzFUzXDajprLu25SCMQo=";
  };

  cargoHash = "sha256-hOPj3c3WIISRqP/9Kpc/Yh9Z/wfAkHQ/731+BkWElIQ=";

  meta = {
    description = "Simple tool to do basic modification of ini files";
    homepage = "https://github.com/domgreen/clini";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Flakebi ];
    mainProgram = "clini";
  };
}
