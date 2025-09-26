{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  pkg-config,
  openssl,
  rdkafka,
}:

let
  pname = "rustus";
  version = "1.1.3";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "s3rius";
    repo = "rustus";
    tag = version;
    hash = "sha256-ALnb6ICg+TZRuHayhozwJ5+imabgjBYX4W42ydhkzv0=";
  };

  cargoHash = "sha256-df92+gp/DtdHwPxJF89zKHjmVWzfrjnD8wAlrPRyyxk=";

  env.OPENSSL_NO_VENDOR = 1;

  # needed to dynamically link rdkafka
  CARGO_FEATURE_DYNAMIC_LINKING = 1;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    rdkafka
  ];

  passthru.updateScript = nix-update-script { };

  checkFlags = [
    # tries to make a network access
    "--skip=data_storage::impls::s3_storage::test::test_successfull_create_upload"
    "--skip=data_storage::impls::s3_storage::test::test_successfull_delete"
    "--skip=data_storage::impls::s3_storage::test::test_successfull_mime"
    "--skip=data_storage::impls::s3_storage::test::test_successfull_upload"
    "--skip=info_storage::impls::redis_storage::tests::deletion_success"
    "--skip=info_storage::impls::redis_storage::tests::success"
    "--skip=notifiers::impls::amqp_notifier::tests::success"
    "--skip=notifiers::impls::http_notifier::tests::forwarded_header"
    "--skip=notifiers::impls::http_notifier::tests::success_request"
    "--skip=notifiers::impls::http_notifier::tests::timeout_request"
    "--skip=notifiers::impls::http_notifier::tests::unknown_url"
    "--skip=notifiers::impls::kafka_notifier::test::simple_success_on_prefix"
    "--skip=notifiers::impls::kafka_notifier::test::simple_success_on_topic"
  ];

  meta = {
    description = "TUS protocol implementation in Rust";
    mainProgram = "rustus";
    homepage = "https://s3rius.github.io/rustus/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
    platforms = lib.platforms.all;
  };
}
