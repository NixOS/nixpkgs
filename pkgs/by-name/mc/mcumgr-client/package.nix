{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  udev,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "mcumgr-client";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "vouch-opensource";
    repo = "mcumgr-client";
    rev = "v${version}";
    hash = "sha256-P5ykIVdWAxuCblMe7kzjswEca/+MsqpizCGUHIpR4qc=";
  };

  cargoHash = "sha256-9jlthe7YQJogcjGv+TOk+O2YW3Xrq6h9tTjXdKHG99k=";

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    lib.optionals stdenv.isLinux [ udev ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.IOKit ];

  meta = with lib; {
    description = "Client for mcumgr commands";
    homepage = "https://github.com/vouch-opensource/mcumgr-client";
    license = licenses.asl20;
    maintainers = with maintainers; [ otavio ];
    mainProgram = "mcumgr-client";
  };
}
