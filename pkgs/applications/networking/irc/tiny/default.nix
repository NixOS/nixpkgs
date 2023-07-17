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
    sha256 = "0m4kpbcfj034ki5n4f1f15gjf173c62c4nig3smmn9k03x18prm0";
  };

  cargoSha256 = "05q3f1wp48mwkz8n0102rwb6jzrgpx3dlbxzf3zcw8r1mblgzim1";

  nativeBuildInputs = lib.optional stdenv.isLinux pkg-config;
  buildInputs = lib.optionals dbusSupport [ dbus ]
                ++ lib.optionals useOpenSSL [ openssl ]
                ++ lib.optional stdenv.isDarwin Foundation;

  buildFeatures = lib.optional notificationSupport "desktop-notifications";

  meta = with lib; {
    description = "A console IRC client";
    homepage = "https://github.com/osa1/tiny";
    changelog = "https://github.com/osa1/tiny/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne vyp ];
  };
}
