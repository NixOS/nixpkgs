{
  rustPlatform,
  libdeltachat,
  pkg-config,
  versionCheckHook,
}:

rustPlatform.buildRustPackage {
  pname = "deltachat-rpc-server";

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
    "deltachat-rpc-server"
  ];

  doCheck = false;

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = libdeltachat.meta // {
    description = "Delta Chat RPC server exposing JSON-RPC core API over standard I/O";
    mainProgram = "deltachat-rpc-server";
  };
}
