{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  sqlite,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "ghostie";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "attriaayush";
    repo = "ghostie";
    rev = "v${version}";
    sha256 = "sha256-lEjJLmBA3dlIVxc8E+UvR7u154QGeCfEbxdgUxAS3Cw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-nGib7MXLiN5PTQoSFf68ClwX5K/aSF8QT9hz20UDGdE=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
      sqlite
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Cocoa
    ];

  # 4 out of 5 tests are notification tests which do not work in nix builds
  doCheck = false;

  preBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Github notifications in your terminal";
    homepage = "https://github.com/attriaayush/ghostie";
    changelog = "https://github.com/attriaayush/ghostie/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    broken = stdenv.hostPlatform.isx86_64 && stdenv.hostPlatform.isDarwin;
    mainProgram = "ghostie";
  };
}
