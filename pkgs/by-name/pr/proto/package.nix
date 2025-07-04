{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
  makeBinaryWrapper,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "proto";
  version = "0.50.0";

  src = fetchFromGitHub {
    owner = "moonrepo";
    repo = "proto";
    rev = "v${version}";
    hash = "sha256-ilbqT5826FB20uCzt2a6QYCD2rDNto7nxz1mjHGDbAA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-bAsFzu1RzOMufFb2WCRd0pDl8O8eVsoZn79BPWql1xg=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
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
