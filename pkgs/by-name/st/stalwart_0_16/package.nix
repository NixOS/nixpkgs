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
  rocksdb,
  callPackage,
  python3Packages,
  cacert,
  libredirect,
  writeTextFile,
  withFoundationdb ? false,
  stalwartEnterprise ? false,
}:
let
  migrate_v016 =
    {
      src,
      version,
    }:
    python3Packages.buildPythonApplication {
      pname = "migrate_v016";
      inherit src version;
      __structuredAttrs = true;
      format = "other";
      dontBuild = true;
      dependencies = [
        python3Packages.urllib3
        python3Packages.requests
      ];
      installPhase = ''
        runHook preInstall
        mkdir -p $out/bin
        cp $src/resources/scripts/migrate_v016.py $out/bin/migrate_v016
        chmod +x $out/bin/migrate_v016
        runHook postInstall
      '';
      postFixUp = ''
        wrapPythonPrograms
      '';
    };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stalwart" + (lib.optionalString stalwartEnterprise "-enterprise");
  version = "0.16.11";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "stalwartlabs";
    repo = "stalwart";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0A8IjetGV4h4qdpm44eZb0sNQ4abulb2+VUAeYWItT0=";
  };

  cargoHash = "sha256-OpoQzNNm5JUrnk1tRZL9JUpDQnGH73Lj6SW52gSthl0=";

  env = {
    # https://docs.rs/openssl/latest/openssl/#manual
    OPENSSL_NO_VENDOR = true;
    OPENSSL_DIR = lib.getDev openssl;
    OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
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

  depsBuildBuild = [
    pkg-config
    zstd
  ];

  nativeBuildInputs = [
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
    "s3"
    "redis"
    "azure"
    "nats"
  ]
  ++ lib.optionals withFoundationdb [ "foundationdb" ]
  ++ lib.optionals stalwartEnterprise [ "enterprise" ];

  cargoBuildFlags = [
    "-p"
    "stalwart"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  doCheck = true;
  nativeCheckInputs = [
    openssl
    # ... panicked at crates/utils/src/lib.rs:94:17: Failed to build TLS connectors: Failed to build platform verifier: unexpected error: No CA certificates were loaded from the system
    cacert
  ];

  # Allow network access during tests on Darwin/macOS
  __darwinAllowLocalNetworking = true;
  # Allow access to DNS settings exposed via config daemon
  # thread ... panicked at tests/src/lib.rs:49:13: Errors: [ Build { ... , message: "Failed to read system DNS config: failed to access System Configuration dynamic store", }, ]
  #  -> https://github.com/hickory-dns/hickory-dns/blob/f09321075b1f97902b7bc4ca4ffda7816fcf2971/crates/resolver/src/system_conf/apple.rs#L21
  #    ->  https://crates.io/crates/system-configuration
  #      -> https://developer.apple.com/documentation/systemconfiguration/scdynamicstore?language=objc
  #        -> "The handle to an open dynamic store session with the system configuration daemon." (configd)
  sandboxProfile = lib.optionalString stdenv.hostPlatform.isDarwin ''
    (allow mach-lookup (global-name "com.apple.SystemConfiguration.configd"))
  '';

  preCheck =
    let
      nsswitch = writeTextFile {
        name = "nsswitch.conf";
        text = ''
          hosts: files dns
        '';
      };
      hosts = writeTextFile {
        name = "hosts";
        text = ''
          127.0.0.1 localhost
        '';
      };
      # ... panicked at tests/src/lib.rs:49:13: Errors: [ Build { ... , message: "Failed to read system DNS config: io error: No such file or directory (os error 2)" }, ... ]
      #   -> https://github.com/hickory-dns/hickory-dns/blob/v0.26.1/crates/resolver/src/system_conf/unix.rs#L25
      #   -> known issue: https://github.com/hickory-dns/hickory-dns/issues/2959
      resolvConf = writeTextFile {
        name = "resolv.conf";
        text = ''
          nameserver 127.0.0.1
        '';
      };
    in
    (lib.optionalString stdenv.hostPlatform.isLinux ''
      export NIX_REDIRECTS="/etc/nsswitch.conf=${nsswitch}:/etc/hosts=${hosts}:/etc/resolv.conf=${resolvConf}"
      export LD_PRELOAD="${libredirect}/lib/libredirect.so"
    '')
    + ''
      export STORE=RocksDb
    '';

  checkFlags = lib.forEach (
    [
      # Require running mysql, postgresql daemon
      "directory::imap::imap_directory"
      "directory::internal::internal_directory"
      "directory::ldap::ldap_directory"
      "directory::sql::sql_directory"
      "directory::oidc::oidc_directory"
      "store::blob::blob_tests"
      "store::lookup::lookup_tests"
      "smtp::lookup::sql::lookup_sql"
      # Require running ldap directory
      "directory::directory_tests"
      # Require running nats or redis instance
      "cluster::broadcast::cluster_tests"
      # flaky tests: ... panicked at tests/src/utils/jmap.rs:434:32: Missing created item 0: { "methodResponses": [ [ "x:Domain/set", { "accountId": "d333333", "notCreated": { "i0": { "type": "primaryKeyViolation", "properties": [ "name" ], "objectId": { "object": "Domain", "id": "c" } } } }, "0" ] ], "sessionState": "a22d1fca" }
      "cluster::stress::stress_tests"
      "imap::imap_tests"
      "system::system_tests"
      "telemetry::telemetry_tests"
      # flaky test: ... panicked at tests/src/utils/jmap.rs:434:32: Missing created item 0: { "methodResponses": [ [ "error", { "type": "serverUnavailable", description": "This server is temporarily unavailable. Attempting this same operation later may succeed." }, "0" ] ], "sessionState": "a22d1fca" }
      "jmap::jmap_tests"
      "automation::automation_tests"
      # thread 'webdav::webdav_tests' (4676902) panicked at tests/src/utils/webdav.rs:591:13: Expected 201 Created but got 409 Conflict
      "webdav::webdav_tests"
      # panicked at tests/src/smtp/inbound/mod.rs:270:18: Unexpected event: WorkerDone { queue_id: 312710620013133824, queue_name: QueueName([100, 101, 102, 97, 117, 108, 116, 0]), status: Completed }
      "smtp::outbound::smtp::smtp_delivery"
      # flaky test: ... panicked at tests/src/smtp/outbound/lmtp.rs:245:5: assertion `left == right` failed
      #   left: 3
      #   right: 4
      "smtp::outbound::lmtp::lmtp_delivery"
      # flaky test: ... panicked at tests/src/smtp/reporting/analyze.rs:110:5: assertion `left == right` failed
      #   left: 0
      #   right: 5
      "smtp::reporting::analyze::report_analyze"
      # flaky test: ... panicked at tests/src/smtp/queue/manager.rs:200:32: Expected rcpt b not found in [Recipient { address: "c", retry: Schedule { due: 1781399468, inner: 0 }, notify: Schedule { due: 1781399473, inner: 0 }, expires: Ttl(9), queue: QueueName([100, 101, 102, 97, 117, 108, 116, 0]), status: Scheduled, flags: 0, orcpt: None }]
      "smtp::queue::manager::queue_due"
      # flaky test: ... panicked at tests/src/smtp/queue/retry.rs:237:5: assertion `left == right` failed
      #   left: [1, 2, 2]
      #  right: [1, 2, 3]
      "smtp::queue::retry::queue_retry"
      # error[E0432]: unresolved import `r2d2_sqlite`
      "backend::sqlite::pool::SqliteConnectionManager::with_init"
      # thread 'smtp::management::queue::manage_queue' panicked at tests/src/smtp/inbound/mod.rs:45:23: No queue event received.
      # NOTE: Test unreliable on high load systems
      "smtp::management::queue::manage_queue"
      # NOTE: long running test(s), needs live dependencies, likely to fail on systems under high load
      "smtp::inbound::antispam::antispam"
      # flaky test (darwin): ... panicked at tests/src/smtp/inbound/mod.rs:287:18:
      # Unexpected event: Refresh
      # (linux): Invalid address: failed to lookup address information: Temporary failure in name resolution
      "smtp::outbound::dane::dane_verify"
    ]
    # ... panicked at tests/src/lib.rs:49:13: Errors: [ Build { ... , message: "Invalid address: failed to lookup address information: Temporary failure in name resolution", }, ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      "smtp::inbound::auth::auth"
      "smtp::inbound::basic::basic_commands"
      "smtp::inbound::data::data"
      "smtp::inbound::dmarc::dmarc"
      "smtp::inbound::ehlo::ehlo"
      "smtp::inbound::limits::limits"
      "smtp::inbound::mail::mail"
      "smtp::inbound::milter::milter_session"
      "smtp::inbound::milter::mta_hook_session"
      "smtp::inbound::rcpt::rcpt"
      "smtp::inbound::rewrite::address_rewrite"
      "smtp::inbound::scripts::sieve_scripts"
      "smtp::inbound::sign::sign_and_seal"
      "smtp::inbound::throttle::throttle_inbound"
      "smtp::inbound::vrfy::vrfy_expn"
      "smtp::lookup::expressions::expressions"
      "smtp::lookup::utils::strategies"
      "smtp::management::report::manage_reports"
      "smtp::outbound::dane::dane_test"
      "smtp::outbound::extensions::extensions"
      "smtp::outbound::fallback_relay::fallback_relay"
      "smtp::outbound::ip_lookup::ip_lookup_strategy"
      "smtp::outbound::mta_sts::mta_sts_verify"
      "smtp::outbound::throttle::throttle_outbound"
      "smtp::outbound::tls::starttls_optional"
      "smtp::queue::concurrent::concurrent_queue"
      "smtp::queue::dsn::generate_dsn"
      "smtp::queue::virtualq::virtual_queue"
      "smtp::reporting::dmarc::report_dmarc"
      "smtp::reporting::scheduler::report_scheduler"
      "smtp::reporting::tls::report_tls"
      "store::search_tests"
      "store::store_tests"
      # since 0.16.10
      "smtp::outbound::dane::dane_downgrade_on_tlsa_servfail"
    ]
  ) (test: "--skip=${test}");

  postInstall = ''
    mkdir -p $out/etc/stalwart

    mkdir -p $out/lib/systemd/system

    substitute resources/systemd/stalwart-mail.service $out/lib/systemd/system/stalwart.service \
      --replace-fail "__PATH__" "$out"

    ln -s ${migrate_v016 { inherit (finalAttrs) src version; }}/bin/migrate_v016 $out/bin/migrate_v016
  '';

  passthru = {
    inherit rocksdb; # make used rocksdb version available (e.g., for backup scripts)
    webui = callPackage ./webui.nix { };
    spam-filter = callPackage ./spam-filter.nix { };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Secure, modern, all-in-one mail and collaboration server";
    longDescription = ''
      Secure, scalable and fluent in every protocol (IMAP, JMAP, SMTP, CalDAV, CardDAV, WebDAV).
    '';
    homepage = "https://github.com/stalwartlabs/stalwart";
    changelog = "https://github.com/stalwartlabs/stalwart/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = [
      lib.licenses.agpl3Only
    ]
    ++ lib.optionals stalwartEnterprise [
      {
        fullName = "Stalwart Enterprise License 2.0 (SELv2) Agreement";
        url = "https://github.com/stalwartlabs/stalwart/blob/${finalAttrs.src.tag}/LICENSES/LicenseRef-SEL.txt";
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
      debtquity
    ];
  };
})
