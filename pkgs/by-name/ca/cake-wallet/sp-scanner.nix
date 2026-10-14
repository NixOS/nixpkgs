{
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cake-wallet-sp-scanner";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "cake-tech";
    repo = "sp_scanner";
    rev = "40ed3ce8319744907bef3b25bc6e0af8428c8724";
    hash = "sha256-JL/y/uyBOFC7DffSStF7SJqG6mRzsQ+WirQHoQ4viGk=";
  };

  sourceRoot = "${finalAttrs.src.name}/rust";

  postPatch = ''
    cp ${./sp-scanner-Cargo.lock} Cargo.lock
  '';

  cargoLock = {
    lockFile = ./sp-scanner-Cargo.lock;
    outputHashes."silentpayments-0.1.1" = "sha256-sLbn0D7Muih+qhW2qwel1kV254SoxVvtf4oPmdT8QNw=";
  };

  passthru.libraryPath = "lib/libsp_scanner.so";
})
