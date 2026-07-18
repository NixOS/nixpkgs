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
  version = "0.58.2";

  src = fetchFromGitHub {
    owner = "moonrepo";
    repo = "proto";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fITyBLT4SyQ7q3zMJ2JpunsBjdZtgiGA19g09PKQcL8=";
  };

  cargoHash = "sha256-tK/nb6g8fjhdCciI5mgq+mvUBwXPsak1VNk8pcWlQrk=";

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
