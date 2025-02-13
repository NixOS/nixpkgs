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

  useFetchCargoVendor = true;
  cargoHash = "sha256-2tpaTVCJJ0c4SyBQU2FjGvCYbdNLXxwIXv8O0+Uibrs=";

  meta = {
    description = "Reverse proxy to bypass the need for port forwarding";
    homepage = "https://git.tudbut.de/tudbut/revpfw3";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tudbut ];
    mainProgram = "revpfw3";
  };
}
