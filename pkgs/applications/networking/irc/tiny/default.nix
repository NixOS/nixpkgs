{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, Foundation
, dbusSupport ? stdenv.isLinux, dbus
# rustls will be used for TLS if useOpenSSL=false
, useOpenSSL ? stdenv.isLinux, openssl
, notificationSupport ? stdenv.isLinux
}:

rustPlatform.buildRustPackage rec {
  pname = "tiny";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "osa1";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-oOaLQh9gJlurHi9awoRh4wQnXwkuOGJLnGQA6di6k1Q=";
  };

  cargoPatches = [ ./Cargo.lock.patch ];

  cargoHash = "sha256-wUBScLNRNAdDZ+HpQjYiExgPJnE9cxviooHePbJI13Q=";

  nativeBuildInputs = lib.optional stdenv.isLinux pkg-config;
  buildInputs = lib.optionals dbusSupport [ dbus ]
                ++ lib.optionals useOpenSSL [ openssl ]
                ++ lib.optional stdenv.isDarwin Foundation;

  buildFeatures = lib.optional notificationSupport "desktop-notifications";

  checkFlags = [
    # flaky test
    "--skip=tests::config::parsing_tab_configs"
  ];

  meta = with lib; {
    description = "A console IRC client";
    homepage = "https://github.com/osa1/tiny";
    changelog = "https://github.com/osa1/tiny/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne vyp ];
  };
}
