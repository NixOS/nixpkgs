{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
  makeBinaryWrapper,
  pkg-config,
  perl,
}:

rustPlatform.buildRustPackage rec {
  pname = "proto";
  version = "0.54.2";

  src = fetchFromGitHub {
    owner = "moonrepo";
    repo = "proto";
    rev = "v${version}";
    hash = "sha256-W20u0QmFp2s+P9gnunudLV8N1LyB+6UnIRBKDePXT8E=";
  };

  cargoHash = "sha256-cryJkz6K8RsDp3Mcc/2YmP9imxkBM30v7fvf61pL4uA=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv

  ];
  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
    perl
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
