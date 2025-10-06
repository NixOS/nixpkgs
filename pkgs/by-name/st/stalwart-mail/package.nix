{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  bzip2,
  openssl,
  sqlite,
  foundationdb,
  zstd,
  stdenv,
  nix-update-script,
  nixosTests,
  rocksdb,
  callPackage,
  withFoundationdb ? false,
  stalwartEnterprise ? false,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stalwart-mail" + (lib.optionalString stalwartEnterprise "-enterprise");
  version = "0.13.4";

  src = fetchFromGitHub {
    owner = "stalwartlabs";
    repo = "stalwart";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1WKmSgDZ3c6+fFKH9+kgrxFYthKQqE1455bFHlVCGhU=";
  };

  cargoHash = "sha256-i6AvyX4RObB9aa+TYvsOW8i9WTcYx8ddP/Jmyr8PWMY=";

  nativeBuildInputs = [
    pkg-config
    protobuf
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    bzip2
    openssl
    sqlite
    zstd
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && withFoundationdb) [ foundationdb ];

  # Issue: https://github.com/stalwartlabs/stalwart/issues/1104
  buildNoDefaultFeatures = true;
  buildFeatures = [
    "sqlite"
    "postgres"
    "mysql"
    "rocks"
    "elastic"
    "s3"
    "redis"
  ]
  ++ lib.optionals withFoundationdb [ "foundationdb" ]
  ++ lib.optionals stalwartEnterprise [ "enterprise" ];

  env = {
    OPENSSL_NO_VENDOR = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
    ROCKSDB_INCLUDE_DIR = "${rocksdb}/include";
    ROCKSDB_LIB_DIR = "${rocksdb}/lib";
  }
  //
    lib.optionalAttrs
      (stdenv.hostPlatform.isLinux && (stdenv.hostPlatform.isAarch64 || stdenv.hostPlatform.isArmv7))
      {
        JEMALLOC_SYS_WITH_LG_PAGE = 16;
      };

  postInstall = ''
    mkdir -p $out/etc/stalwart

    mkdir -p $out/lib/systemd/system

    substitute resources/systemd/stalwart-mail.service $out/lib/systemd/system/stalwart-mail.service \
      --replace "__PATH__" "$out"
  '';

  checkFlags = lib.forEach [
    # Require running mysql, postgresql daemon
    "directory::imap::imap_directory"
    "directory::internal::internal_directory"
    "directory::ldap::ldap_directory"
    "directory::sql::sql_directory"
    "directory::oidc::oidc_directory"
    "store::blob::blob_tests"
    "store::lookup::lookup_tests"
    "smtp::lookup::sql::lookup_sql"
    # thread 'directory::smtp::lmtp_directory' panicked at tests/src/store/mod.rs:122:44:
    # called `Result::unwrap()` on an `Err` value: Os { code: 2, kind: NotFound, message: "No such file or directory" }
    "directory::smtp::lmtp_directory"
    # thread 'imap::imap_tests' panicked at tests/src/imap/mod.rs:436:14:
    # Missing store type. Try running `STORE=<store_type> cargo test`: NotPresent
    "imap::imap_tests"
    # thread 'jmap::jmap_tests' panicked at tests/src/jmap/mod.rs:303:14:
    # Missing store type. Try running `STORE=<store_type> cargo test`: NotPresent
    "jmap::jmap_tests"
    # Failed to read system DNS config: io error: No such file or directory (os error 2)
    "smtp::inbound::data::data"
    # Expected "X-My-Header: true" but got Received: from foobar.net (unknown [10.0.0.123])
    "smtp::inbound::scripts::sieve_scripts"
    # thread 'smtp::outbound::lmtp::lmtp_delivery' panicked at tests/src/smtp/session.rs:313:13:
    # Expected "<invalid@domain.org> (failed to lookup" but got From: "Mail Delivery Subsystem" <MAILER-DAEMON@localhost>
    "smtp::outbound::lmtp::lmtp_delivery"
    # thread 'smtp::outbound::extensions::extensions' panicked at tests/src/smtp/inbound/mod.rs:45:23:
    # No queue event received.
    "smtp::outbound::extensions::extensions"
    # panicked at tests/src/smtp/outbound/smtp.rs:173:5:
    "smtp::outbound::smtp::smtp_delivery"
    # panicked at tests/src/smtp/outbound/lmtp.rs
    "smtp::outbound::lmtp::lmtp_delivery"
    # thread 'smtp::queue::retry::queue_retry' panicked at tests/src/smtp/queue/retry.rs:119:5:
    # assertion `left == right` failed
    #   left: [1, 2, 2]
    #  right: [1, 2, 3]
    "smtp::queue::retry::queue_retry"
    # thread 'smtp::queue::virtualq::virtual_queue' panicked at /build/source/crates/store/src/dispatch/store.rs:548:14:
    # called `Result::unwrap()` on an `Err` value: Error(Event { inner: Store(MysqlError), keys: [(Reason, String("Input/output error: Input/output error: Connection refused (os error 111)")), (CausedBy, String("crates/store/src/dispatch/store.rs:301"))] })
    "smtp::queue::virtualq::virtual_queue"
    # Missing store type. Try running `STORE=<store_type> cargo test`: NotPresent
    "store::store_tests"
    # Missing store type. Try running `STORE=<store_type> cargo test`: NotPresent
    "cluster::cluster_tests"
    # Missing store type. Try running `STORE=<store_type> cargo test`: NotPresent
    "webdav::webdav_tests"
    # thread 'config::parser::tests::toml_parse' panicked at crates/utils/src/config/parser.rs:463:58:
    # called `Result::unwrap()` on an `Err` value: "Expected ['\\n'] but found '!' in value at line 70."
    "config::parser::tests::toml_parse"
    # error[E0432]: unresolved import `r2d2_sqlite`
    # use of undeclared crate or module `r2d2_sqlite`
    "backend::sqlite::pool::SqliteConnectionManager::with_init"
    # thread 'smtp::reporting::analyze::report_analyze' panicked at tests/src/smtp/reporting/analyze.rs:88:5:
    # assertion `left == right` failed
    #   left: 0
    #  right: 12
    "smtp::reporting::analyze::report_analyze"
    # thread 'smtp::inbound::dmarc::dmarc' panicked at tests/src/smtp/inbound/mod.rs:59:26:
    # Expected empty queue but got Reload
    "smtp::inbound::dmarc::dmarc"
    # thread 'smtp::queue::concurrent::concurrent_queue' panicked at tests/src/smtp/inbound/mod.rs:65:9:
    # assertion `left == right` failed
    "smtp::queue::concurrent::concurrent_queue"
    # Failed to read system DNS config: io error: No such file or directory (os error 2)
    "smtp::inbound::auth::auth"
    # Failed to read system DNS config: io error: No such file or directory (os error 2)
    "smtp::inbound::antispam::antispam"
    # Failed to read system DNS config: io error: No such file or directory (os error 2)
    "smtp::inbound::vrfy::vrfy_expn"
    # thread 'smtp::management::queue::manage_queue' panicked at tests/src/smtp/inbound/mod.rs:45:23:
    # No queue event received.
    # NOTE: Test unreliable on high load systems
    "smtp::management::queue::manage_queue"
    # thread 'responses::tests::parse_responses' panicked at crates/dav-proto/src/responses/mod.rs:671:17:
    # assertion `left == right` failed: failed for 008.xml
    #   left: ElementEnd
    #  right: Bytes([...])
    "responses::tests::parse_responses"
  ] (test: "--skip=${test}");

  doCheck = !(stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);

  # Allow network access during tests on Darwin/macOS
  __darwinAllowLocalNetworking = true;

  passthru = {
    inherit rocksdb; # make used rocksdb version available (e.g., for backup scripts)
    webadmin = callPackage ./webadmin.nix { };
    spam-filter = callPackage ./spam-filter.nix { };
    updateScript = nix-update-script { };
    tests.stalwart-mail = nixosTests.stalwart-mail;
  };

  meta = {
    description = "Secure & Modern All-in-One Mail Server (IMAP, JMAP, SMTP)";
    homepage = "https://github.com/stalwartlabs/mail-server";
    changelog = "https://github.com/stalwartlabs/mail-server/blob/main/CHANGELOG.md";
    license = [
      lib.licenses.agpl3Only
    ]
    ++ lib.optionals stalwartEnterprise [
      {
        fullName = "Stalwart Enterprise License 1.0 (SELv1) Agreement";
        url = "https://github.com/stalwartlabs/mail-server/blob/main/LICENSES/LicenseRef-SEL.txt";
        free = false;
        redistributable = false;
      }
    ];

    mainProgram = "stalwart";
    maintainers = with lib.maintainers; [
      happysalada
      onny
      oddlama
      pandapip1
      norpol
    ];
  };
})
