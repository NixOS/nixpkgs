{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
, libiconv
, makeBinaryWrapper
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "proto";
  version = "0.35.3";

  src = fetchFromGitHub {
    owner = "moonrepo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ybWiJy4U3l0g2DdoebZ0XUPRres7+DLz3tES7I7M/JQ=";
  };

  cargoHash = "sha256-1DlDqzymrTFrtgDcgyoev864EBw8BGcxyquMt28NPTw=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
    libiconv
  ];
  nativeBuildInputs = [ makeBinaryWrapper pkg-config ];

  # Tests requires network access
  doCheck = false;
  cargoBuildFlags = [ "--bin proto" "--bin proto-shim" ];

  postInstall = ''
    # proto looks up a proto-shim executable file in $PROTO_LOOKUP_DIR
    wrapProgram $out/bin/${pname} \
      --set PROTO_LOOKUP_DIR $out/bin
  '';

  meta = {
    description = "A pluggable multi-language version manager";
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
