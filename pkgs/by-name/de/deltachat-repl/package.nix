{
  rustPlatform,
  libdeltachat,
  pkg-config,
}:

rustPlatform.buildRustPackage {
  pname = "deltachat-repl";

  inherit (libdeltachat)
    version
    src
    cargoDeps
    buildInputs
    ;

  nativeBuildInputs = [
    pkg-config
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

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
