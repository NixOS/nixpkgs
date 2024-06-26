{
  lib,
  rustPlatform,
  libdeltachat,
  perl,
  pkg-config,
}:

rustPlatform.buildRustPackage {
  pname = "deltachat-repl";

  inherit (libdeltachat)
    version
    src
    cargoLock
    buildInputs
    ;

  nativeBuildInputs = [
    perl
    pkg-config
  ];

  cargoBuildFlags = [
    "--package"
    "deltachat-repl"
  ];

  doCheck = false;

  meta = libdeltachat.meta // {
    description = "Delta Chat CLI client";
    mainProgram = "deltachat-repl";
  };
}
