{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "buckle";
  version = "1.1.0";
  cargoHash = "sha256-O90/Xo9WjLVGFEkh6S6IyvanceRBJHneEret6W8e5Yc=";

  src = fetchFromGitHub {
    owner = "benbrittain";
    repo = "buckle";
    rev = "v${version}";
    sha256 = "sha256-eWhcDzw+6I5N0dse5avwhcQ/y6YZ6b3QKyBwWBrA/xo=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  checkFlags = [
    # Both tests access the network.
    "--skip=test_buck2_latest"
    "--skip=test_buck2_specific_version"
  ];

  meta = with lib; {
    description = "A buck2 launcher";
    longDescription = ''
      Buckle is a launcher for [Buck2](https://buck2.build). It manages
      Buck2 on a per-project basis. This enables a project or team to do
      seamless upgrades of their build system tooling. It is designed to
      be minimally intrusive. Buckle only manages fetching Buck2 and
      enforcing the prelude is upgraded in sync.
    '';
    homepage = "https://github.com/benbrittain/buckle";
    license = licenses.mit;
    maintainers = with maintainers; [ cbarrete ];
    mainProgram = "buckle";
  };
}
