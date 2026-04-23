{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "sdns";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "semihalev";
    repo = "sdns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5YQnViBz5j/1Q7FG3Vh73kckNtyQp4FjNy1dydRuJc0=";
  };

  vendorHash = "sha256-Qv0YXROeRR39nzT4QcF1J7vJgMP5DW5id7gi5nM97tA=";

  postPatch = ''
    substituteInPlace dnsutil/dnsutil_test.go \
        --replace-fail "TestExchange" "SkipExchange"
    substituteInPlace middleware/cache/cache_test.go \
        --replace-fail "Test_Cache_CNAME" "Skip_Cache_CNAME" \
        --replace-fail "Test_Cache_ResponseWriter" "Skip_Cache_ResponseWriter"
    substituteInPlace middleware/failover/failover_test.go \
        --replace-fail "Test_Failover" "Skip_Failover"
    substituteInPlace middleware/forwarder/forwarder_test.go \
        --replace-fail "Test_Forwarder" "Skip_Forwarder"
    substituteInPlace middleware/resolver/client_test.go \
        --replace-fail "Test_Client" "Skip_Client"
    substituteInPlace middleware/resolver/resolver_test.go \
        --replace-fail "Test_resolver" "Skip_resolver"
    substituteInPlace middleware/resolver/handler_test.go \
        --replace-fail "Test_handler" "Skip_handler"
    substituteInPlace server/doh/doh_test.go \
        --replace-fail "Test_dohWire" "Skip_dohWire" \
        --replace-fail "Test_dohJSON" "Skip_dohJSON"
  '';

  meta = {
    description = "High-performance, recursive DNS resolver server with DNSSEC support, focused on preserving privacy.";
    mainProgram = "sdns";
    homepage = "https://sdns.dev";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [abbe];
    changelog = "https://github.com/semihalev/sdns/releases/tag/v${finalAttrs.version}";
  };
})
