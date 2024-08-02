{ rustPlatform
, libdeltachat
, perl
, pkg-config
}:

rustPlatform.buildRustPackage {
  pname = "deltachat-rpc-server";

  inherit (libdeltachat) version src cargoLock buildInputs;

  nativeBuildInputs = [
    perl
    pkg-config
  ];

  cargoBuildFlags = [ "--package" "deltachat-rpc-server" ];

  doCheck = false;

  meta = libdeltachat.meta // {
    description = "Delta Chat RPC server exposing JSON-RPC core API over standard I/O";
    mainProgram = "deltachat-rpc-server";
  };
}
