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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "proto";
  version = "0.63.1";

  src = fetchFromGitHub {
    owner = "moonrepo";
    repo = "proto";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Ou5v9gyrtUm/Xrt3scm8GC6AxjfZMCJHT0MdP7vL9sM=";
  };

  cargoHash = "sha256-N1YKoU7A9M4EQB29nccXU4Gbt4c/Cnyjvhj0wFcTnoY=";

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
    changelog = "https://github.com/moonrepo/proto/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nokazn ];
    mainProgram = "proto";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
