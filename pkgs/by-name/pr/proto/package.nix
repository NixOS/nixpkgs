{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
  libiconv,
  makeBinaryWrapper,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "proto";
  version = "0.43.1";

  src = fetchFromGitHub {
    owner = "moonrepo";
    repo = "proto";
    rev = "v${version}";
    hash = "sha256-OvDkDbW7w805ZMLVg3yJqZCp6Xn8oW2dMJe/CnWROoo=";
  };

  cargoHash = "sha256-ataFb/+gPkOjDZYht/c+A75H/GBSW9toPBRQ6H16U9g=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
    libiconv
  ];
  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
  ];

  # Tests requires network access
  doCheck = false;
  cargoBuildFlags = [
    "--bin proto"
    "--bin proto-shim"
  ];

  postInstall = ''
    # proto looks up a proto-shim executable file in $PROTO_LOOKUP_DIR
    wrapProgram $out/bin/proto \
      --set PROTO_LOOKUP_DIR $out/bin
  '';

  meta = {
    description = "Pluggable multi-language version manager";
    longDescription = ''
      proto is a pluggable next-generation version manager for multiple programming languages. A unified toolchain.
    '';
    homepage = "https://moonrepo.dev/proto";
    changelog = "https://github.com/moonrepo/proto/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nokazn ];
    mainProgram = "proto";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
