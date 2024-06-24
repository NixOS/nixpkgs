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
  version = "0.37.1";

  src = fetchFromGitHub {
    owner = "moonrepo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-IqXxjR+M1OCRKUA2HCT6WQvdBMOa0efT8m+drhyQCoE=";
  };

  cargoHash = "sha256-NnTiT1jLMo9EfYau+U0FiAC+V67GnoI90vSsotwniio=";

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
