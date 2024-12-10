{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  Foundation,
  dbusSupport ? stdenv.isLinux,
  dbus,
  # rustls will be used for TLS if useOpenSSL=false
  useOpenSSL ? stdenv.isLinux,
  openssl,
  notificationSupport ? stdenv.isLinux,
}:

rustPlatform.buildRustPackage rec {
  pname = "tiny";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "osa1";
    repo = "tiny";
    rev = "v${version}";
    hash = "sha256-VlKhOHNggT+FbMvE/N2JQOJf0uB1N69HHdP09u89qSk=";
  };

  cargoHash = "sha256-AhQCfLCoJU7o8s+XL3hDOPmZi9QjOxXSA9uglA1KSuY=";

  # Cargo.lock is outdated
  preConfigure = ''
    cargo metadata --offline
  '';

  nativeBuildInputs = lib.optional stdenv.isLinux pkg-config;
  buildInputs =
    lib.optionals dbusSupport [ dbus ]
    ++ lib.optionals useOpenSSL [ openssl ]
    ++ lib.optional stdenv.isDarwin Foundation;

  buildFeatures = lib.optional notificationSupport "desktop-notifications";

  meta = with lib; {
    description = "A console IRC client";
    homepage = "https://github.com/osa1/tiny";
    changelog = "https://github.com/osa1/tiny/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      Br1ght0ne
      vyp
    ];
    mainProgram = "tiny";
  };
}
