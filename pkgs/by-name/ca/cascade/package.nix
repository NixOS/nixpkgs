{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "cascade";
  version = "0.1.0-alpha2";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = "cascade";
    rev = "v${version}";
    hash = "sha256-5GcCVpVioYlMiHG4pNQIa/53Yaqdu5O8y0GLwawwTGg=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "domain-0.11.1-dev" = "sha256-dNzfnjHS3s8pWNvCASm92va6XoXJfUbzidNybssc1U4=";
      "kmip-protocol-0.5.0" = "sha256-QhPG1yFQd+kKowBJAZl7TphGCEALhyJhwv1qj5pqK0E=";
      "kmip-ttlv-0.4.0" = "sha256-klq3Aktg0cxsyDOL7Kb40Nuu/4tUX6WlE33gTKyeW+4=";
    };
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = {
    description = "A friendly DNSSEC signing solution: sensible defaults, controllability, observability and flexibility";
    homepage = "https://github.com/NLnetLabs/cascade";
    changelog = "https://github.com/NLnetLabs/cascade/blob/${src.rev}/Changelog.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ _0x4A6F ];
    mainProgram = "cascade";
    broken = stdenv.hostPlatform.isDarwin;
  };
}
