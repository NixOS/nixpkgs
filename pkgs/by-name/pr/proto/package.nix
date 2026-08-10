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
  version = "0.60.0";

  src = fetchFromGitHub {
    owner = "moonrepo";
    repo = "proto";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Fzrio8LwfZW//k10aqj/gwVDcrmui/GlQS/BmZASG1A=";
  };

  cargoHash = "sha256-QoX2ubtcjhTM7Q5pTPdI2QH1ZC9rssG3KHdocdQ26Lk=";

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
