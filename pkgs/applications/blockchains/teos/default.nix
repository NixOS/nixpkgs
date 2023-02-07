{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, llvmPackages
, openssl
, pkg-config
, perl
, protobuf
, rustfmt
, Security
, SystemConfiguration
}:

let
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "talaia-labs";
    repo = "rust-teos";
    rev = "v${version}";
    hash = "sha256-UrzH9xmhVq12TcSUQ1AihCG1sNGcy/N8LDsZINVKFkY=";
  };

  common.meta = with lib; {
    homepage = "https://github.com/talaia-labs/rust-teos";
    license = licenses.mit;
    maintainers = with maintainers; [ seberm ];
    platforms = platforms.unix;
  };

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];

  nativeBuildInputs = [
    perl  # used by openssl-sys to configure
    protobuf
    pkg-config
    rustfmt
    rustPlatform.bindgenHook
  ];
in
{
  teos = rustPlatform.buildRustPackage {
    pname = "teos";
    cargoSha256 = "sha256-U0imKEPszlBOaS6xEd3kfzy/w2SYe3EY/E1e0L+ViDk=";
    buildAndTestSubdir = "teos";

    inherit version src buildInputs nativeBuildInputs;

    meta = common.meta // {
      description = "A Lightning watchtower compliant with BOLT13, written in Rust";
    };

    cargoTestFlags = [
      "--workspace"
    ];
  };

  teos-watchtower-plugin = rustPlatform.buildRustPackage {
    pname = "teos-watchtower-plugin";
    cargoSha256 = "sha256-3ke1qTFw/4I5dPLuPjIGp1n2C/eRfPB7A6ErMFfwUzE=";
    buildAndTestSubdir = "watchtower-plugin";

    inherit version src buildInputs nativeBuildInputs;

    meta = common.meta // {
      description = "A Lightning watchtower plugin for clightning";
    };

    checkFlags = lib.optionals stdenv.isLinux [
      "--skip=retrier::tests::test_manage_retry_misbehaving"
      "--skip=retrier::tests::test_manage_retry_reachable"
      "--skip=retrier::tests::test_manage_retry_rejected"
      "--skip=retrier::tests::test_manage_retry_subscription_error"
    ] ++ lib.optionals (stdenv.isLinux && stdenv.isAarch64) [
      "--skip=retrier::tests::test_manage_retry_while_idle"
    ] ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
      "--skip=retrier::tests::test_manage_retry_unreachable"
      "--skip=retrier::tests::test_retry_tower_rejected"
      "--skip=retrier::tests::test_retry_tower_subscription_error"
    ];
  };
}
