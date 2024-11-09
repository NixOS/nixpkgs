{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "doctave";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "doctave";
    repo = "doctave";
    rev = version;
    hash = "sha256-8mGSFQozyLoGua9mwyqfDcYNMtbeWp9Phb0vaje+AJ0=";
  };

  postPatch = ''
    ln -sf ${./Cargo.lock} Cargo.lock
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "doctave-markdown-0.9.0" = "sha256-DDeb91DgLx7vOYHwoDy6+/532q/3/myJUZDqjq7ejJ0=";
    };
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  meta = {
    description = "Batteries-included developer documentation site generator";
    homepage = "https://github.com/doctave/doctave";
    changelog = "https://github.com/doctave/doctave/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "doctave";
  };
}
