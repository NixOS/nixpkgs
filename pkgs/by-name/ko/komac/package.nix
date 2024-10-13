{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, openssl
, rustPlatform
, darwin
, testers
, komac
, dbus
, zstd
}:

let
  version = "2.6.0";
  src = fetchFromGitHub {
    owner = "russellbanks";
    repo = "Komac";
    rev = "v${version}";
    hash = "sha256-YFaa2kU42NlhRivBEPV1mSr3j95P4NFwUKM0Xx8tpfg=";
  };
in
rustPlatform.buildRustPackage {
  inherit version src;

  pname = "komac";

  cargoHash = "sha256-kb18phtY5rRNUw0ZaZu2tipAaOURSy+2duf/+cOj5Y8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    dbus
    openssl
    zstd
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
    YRX_REGENERATE_MODULES_RS = "no";
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
