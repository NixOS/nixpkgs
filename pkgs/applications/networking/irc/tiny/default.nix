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
<<<<<<< HEAD
  version = "0.11.0";
=======
  version = "0.10.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "osa1";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-oOaLQh9gJlurHi9awoRh4wQnXwkuOGJLnGQA6di6k1Q=";
  };

  cargoPatches = [ ./Cargo.lock.patch ];

  cargoHash = "sha256-wUBScLNRNAdDZ+HpQjYiExgPJnE9cxviooHePbJI13Q=";
=======
    sha256 = "177d1x4z0mh0p7c5ldq70cn1j3pac50d8cil2ni50hl49c3x6yy1";
  };

  cargoSha256 = "05q3f1wp48mwkz8n0102rwb6jzrgpx3dlbxzf3zcw8r1mblgzim1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = lib.optional stdenv.isLinux pkg-config;
  buildInputs = lib.optionals dbusSupport [ dbus ]
                ++ lib.optionals useOpenSSL [ openssl ]
                ++ lib.optional stdenv.isDarwin Foundation;

  buildFeatures = lib.optional notificationSupport "desktop-notifications";

<<<<<<< HEAD
  checkFlags = [
    # flaky test
    "--skip=tests::config::parsing_tab_configs"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A console IRC client";
    homepage = "https://github.com/osa1/tiny";
    changelog = "https://github.com/osa1/tiny/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne vyp ];
  };
}
