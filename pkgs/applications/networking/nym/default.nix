{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, Security
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "nym";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "nymtech";
    repo = "nym";
    rev = "v${version}";
    sha256 = "sha256-bZXbteryXkOxft63zUMWdpBgbDSvrBHQY3f70/+mBtI=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "sphinx-0.1.0" = "sha256-/NW6jHZIi2Pe/m6o86FR0pLsSuRVuLYNTTPU7JEf/Us=";
    };
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security libiconv ];

  checkType = "debug";

  passthru.updateScript = ./update.sh;

  checkFlags = [
    "--skip commands::upgrade::upgrade_tests"
    "--skip allowed_hosts::tests::creating_a_new_host_store"
    "--skip allowed_hosts::tests::getting_the_domain_root"
    "--skip allowed_hosts::tests::requests_to_allowed_hosts"
    "--skip allowed_hosts::tests::requests_to_unknown_hosts"
  ];

  meta = with lib; {
    description = "A mixnet providing IP-level privacy";
    longDescription = ''
      Nym routes IP packets through other participating nodes to hide their source and destination.
      In contrast with Tor, it prevents timing attacks at the cost of latency.
    '';
    homepage = "https://nymtech.net";
    license = licenses.asl20;
    maintainers = [ maintainers.ehmry ];
    platforms = platforms.all;
  };
}
