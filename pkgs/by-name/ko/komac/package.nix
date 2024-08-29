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
  version = "2.5.0";
  src = fetchFromGitHub {
    owner = "russellbanks";
    repo = "Komac";
    rev = "v${version}";
    hash = "sha256-X+LZ6D7MTt/0k4hLvk7TVKiL174QDdxwPKu01MyREYw=";
  };
in
rustPlatform.buildRustPackage {
  inherit version src;

  pname = "komac";

  cargoHash = "sha256-VBfXD1IF6D1z28dzXfKRz3/Hh2KRxcsYRRDV8e/Akww=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    dbus
    openssl
    zstd
  ] ++ lib.optionals stdenv.isDarwin [
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
