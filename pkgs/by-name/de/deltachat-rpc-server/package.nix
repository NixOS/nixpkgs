{
  rustPlatform,
  libdeltachat,
  pkg-config,
<<<<<<< HEAD
  versionCheckHook,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = libdeltachat.meta // {
    description = "Delta Chat RPC server exposing JSON-RPC core API over standard I/O";
    mainProgram = "deltachat-rpc-server";
  };
}
