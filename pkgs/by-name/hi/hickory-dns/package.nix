{
  cacert,
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hickory-dns";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "hickory-dns";
    repo = "hickory-dns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1VryKiE7kri7XQmVpCmZjc98L9iN60UVz5bNgphjDAU=";
  };

  cargoHash = "sha256-El5NuGevzTpHJP5MVYjyED0UwV7xM9iwv/X7x5Gz/+I=";

  buildFeatures = [
    "blocklist"
    "dnssec-ring"
    "h3-ring"
    "https-ring"
    "prometheus-metrics"
    "quic-ring"
    "recursor"
    "rustls-platform-verifier"
    "systemd"
    "tls-ring"
  ];

  # prometheus-metrics adds a required `metrics_label` method to ZoneHandler,
  # but the integration test impls don't provide it, so exclude it from tests
  # https://github.com/hickory-dns/hickory-dns/pull/3599
  checkFeatures = lib.subtractLists [ "prometheus-metrics" ] finalAttrs.buildFeatures;

  # skip tests that need network or public resolvers
  checkFlags = [
    "--skip=client::tests::async_client"
    "--skip=client::tests::readme_example"
    "--skip=client_future_tests::test_query_https"
    "--skip=client_future_tests::test_query_tcp_ipv4"
    "--skip=client_future_tests::test_query_udp_ipv4"
    "--skip=client_future_tests::test_timeout_query_udp"
    "--skip=client_tests::test_nsec3_nxdomain"
    "--skip=client_tests::test_query_udp_edns"
    "--skip=client_tests::test_secure_query_example_tcp"
    "--skip=client_tests::test_timeout_query_tcp"
    "--skip=client_tests::test_timeout_query_udp"
    "--skip=connection_provider::tests"
    "--skip=dnssec_client_handle_tests::test_secure_query_example_tcp"
    "--skip=forwarder::test_lookup"
    "--skip=h2::tests::test_https_google"
    "--skip=h2::tests::test_https_google_with_pure_ip_address_server"
    "--skip=h3::h3_client_stream::tests::test_h3_client_stream_clonable"
    "--skip=h3::h3_client_stream::tests::test_h3_cloudflare"
    "--skip=h3::h3_client_stream::tests::test_h3_google"
    "--skip=h3::h3_client_stream::tests::test_h3_google_with_pure_ip_address_server"
    "--skip=name_server::tests::test_name_server"
    "--skip=name_server_pool::tests::test_multi_use_conns"
    "--skip=named_tests::test_forward"
    "--skip=resolver::tests::test_domain_search"
    "--skip=resolver::tests::test_fqdn"
    "--skip=resolver::tests::test_idna"
    "--skip=resolver::tests::test_large_ndots"
    "--skip=resolver::tests::test_lookup_cloudflare"
    "--skip=resolver::tests::test_lookup_google"
    "--skip=resolver::tests::test_ndots"
    "--skip=resolver::tests::test_search_list"
    "--skip=tests::readme_example"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  preCheck = ''
    # integration tests spin up the server which needs a cert bundle
    export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt";

    # skip some doctests that need network
    substituteInPlace crates/resolver/src/lib.rs --replace-fail '//! ```rust' '//! ```rust,no_run'
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rust based DNS client, server, and resolver";
    homepage = "https://hickory-dns.org/";
    changelog = "https://github.com/hickory-dns/hickory-dns/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [
      adamcstephens
      colinsane
    ];
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "hickory-dns";
  };
})
