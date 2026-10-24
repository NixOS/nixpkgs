{
  lib,
  stdenv,
  buildNpmPackage,
  libpcap,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (
  finalAttrs:
  let
    evebox-webapp = buildNpmPackage {
      pname = "evebox-webapp";
      inherit (finalAttrs) version src;

      __structuredAttrs = true;

      sourceRoot = "source/webapp";
      npmDepsHash = "sha256-IYtAHNgaUIPM00dV3mcpo7GnOxUaKH6YafEvLViGz00=";

      postPatch = ''
        echo 'export const GIT_REV = "${finalAttrs.version}";' > src/gitrev.ts
      '';

      dontNpmInstall = true;
      installPhase = ''
        runHook preInstall
        cp -r dist $out
        runHook postInstall
      '';
    };
  in
  {
    pname = "evebox";
    version = "0.28.0";

    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "jasonish";
      repo = "evebox";
      tag = finalAttrs.version;
      hash = "sha256-+aXq665DeZlBHVrXRc2ubLsnuYhkZ7WahirCqrKxgVM=";
    };

    cargoHash = "sha256-hz1UpTMUPkCHiY/sjFKe1oqICYEGw1J3F1srDIfxuSA=";

    env.BUILD_REV = finalAttrs.version;

    buildInputs = [ libpcap ];

    preBuild = ''
      mkdir -p resources
      cp -r ${evebox-webapp} resources/webapp
    '';

    # Skip any tests that rely on Internet access
    checkFlags = [
      "--skip=agent::channel::tests::rejected_upload_returns_a_terminal_error_promptly"
      "--skip=agent::channel::tests::server_cancel_aborts_an_active_http_upload_promptly"
      "--skip=agent::channel::tests::worker_extracts_and_uploads_a_complete_pcap"
      "--skip=server::api::admin::tests::agent_key_endpoints_manage_the_key_lifecycle"
      "--skip=server::api::admin::tests::agent_key_endpoints_require_authentication"
      "--skip=server::api::admin::tests::kv_config_endpoint_refuses_the_pcap_routing_key"
      "--skip=server::api::admin::tests::pcap_routing_endpoints_require_authentication"
      "--skip=server::api::admin::tests::pcap_routing_endpoints_roundtrip"
      "--skip=server::api::agent::tests::browser_disconnect_reaches_agent_and_followup_request_works"
      "--skip=server::api::agent::tests::channel_replacement_fails_the_in_flight_request"
      "--skip=server::api::agent::tests::disconnect_before_upload_fails_promptly_and_releases_permits"
      "--skip=server::api::agent::tests::first_byte_timeout_sends_cancel_and_cleans_up"
      "--skip=server::api::agent::tests::missing_terminal_result_fails_the_stream_and_cleans_up_promptly"
      "--skip=server::api::agent::tests::remote_round_trip_supports_flow_expression_and_all_filters"
      "--skip=server::api::agent::tests::remote_truncation_and_native_get_validation_keep_api_parity"
      "--skip=server::api::agent::tests::unresponsive_agent_fails_fast_before_dispatch"
      "--skip=server::api::agent::tests::upload_endpoint_rejects_bad_and_reused_tokens_over_http"
    ];

    nativeInstallCheckInputs = [ versionCheckHook ];
    doInstallCheck = true;

    meta = {
      description = "Web Based Event Viewer (GUI) for Suricata EVE Events in Elastic Search";
      homepage = "https://evebox.org/";
      changelog = "https://github.com/jasonish/evebox/releases/tag/${finalAttrs.src.tag}";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        felbinger
        xddxdd
      ];
      broken = stdenv.hostPlatform.isDarwin;
    };
  }
)
