{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, openssl
, rustPlatform
, darwin
, testers
, komac
, zstd
}:

let
  version = "2.3.0";
  src = fetchFromGitHub {
    owner = "russellbanks";
    repo = "Komac";
    rev = "v${version}";
    hash = "sha256-swl2WEFE2Jglo76KseDlb5K8vQ7DCMcLlxAFhdqTv7I=";
  };
in
rustPlatform.buildRustPackage {
  inherit version src;

  pname = "komac";

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    zstd
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  passthru.tests.version = testers.testVersion {
    inherit version;

    package = komac;
    command = "komac --version";
  };

  meta = with lib; {
    description = "Community Manifest Creator for WinGet";
    homepage = "https://github.com/russellbanks/Komac";
    changelog = "https://github.com/russellbanks/Komac/releases/tag/${src.rev}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kachick HeitorAugustoLN ];
    mainProgram = "komac";
  };
}
