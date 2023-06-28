{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2_1_5
, openssl
, zlib
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "projectable";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "dzfrias";
    repo = "projectable";
    rev = version;
    hash = "sha256-mN8kqh17qGJWOwrdH9fCPApFQBbgCs6FaVg38SNJGP0=";
  };

  cargoHash = "sha256-SQ117gFkqex3GFl7RnorSfPo7e0Eefg1l3L0Vyi/tpU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2_1_5
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  meta = with lib; {
    description = "A TUI file manager built for projects";
    homepage = "https://github.com/dzfrias/projectable";
    changelog = "https://github.com/dzfrias/projectable/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "prj";
  };
}
