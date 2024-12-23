{
  lib,
  stdenv,
  fetchFromGitHub,
  nixosTests,
  yarnConfigHook,
  yarnBuildHook,
  fetchYarnDeps,
  rustPlatform,
  nix-update-script,
  pnpm,
  typescript,
  nodejs,
  protobuf,
  protoc-gen-js,
  protoc-gen-grpc-web,
  gnumake,
  cmake,
  rdkafka,
}:
let
  version = "4.10.2";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack";
    rev = "v${version}";
    hash = "sha256-XVwPz2mT5a1E0z/SIQNZkzdPQ/M75dRILDPiW23BgOs=";
  };

  grpc-web = stdenv.mkDerivation (finalAttrs: {
    pname = "chirpstack-grpc-web";
    inherit version;
    src = "${src}/api/grpc-web";

    offlineCache = fetchYarnDeps {
      yarnLock = "${finalAttrs.src}/yarn.lock";
      hash = "sha256-T2+N2U0QAVXQBXIvSgpOpO/XLNyAGmvH67VQbTkm2kk=";
    };

    buildPhase = ''
      runHook preBuild

      substituteInPlace Makefile \
      --replace-fail "../proto" "${src}/api/proto" \
      --replace-fail "./node_modules/grpc-tools" "${protobuf}"

      make common gw api integration google-api

      runHook postBuild
    '';

    nativeBuildInputs = [
      yarnConfigHook
      nodejs
      protobuf
      protoc-gen-js
      protoc-gen-grpc-web
      gnumake
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r . $out

      runHook postInstall
    '';
  });

  ui = stdenv.mkDerivation (finalAttrs: {
    pname = "chirpstack-ui";
    inherit version;
    src = "${src}/ui";

    offlineCache = fetchYarnDeps {
      yarnLock = "${finalAttrs.src}/yarn.lock";
      hash = "sha256-aUlVQMH2jtY5pYrQNFmOLM3GJG0/oH4glE4nFU0PE+A=";
    };

    preConfigure = ''
      substituteInPlace package.json \
        --replace-fail "../api/grpc-web" "${grpc-web}"
    '';

    preBuild = ''
      PATH=$PATH:$PWD/node_modules/.bin
    '';

    nativeBuildInputs = [
      yarnConfigHook
      yarnBuildHook
      typescript
      nodejs
    ];

    installPhase = ''
      runHook preInstall

      mv build $out

      runHook postInstall
    '';
  });
in
rustPlatform.buildRustPackage {
  pname = "chirpstack";
  inherit src version;

  cargoHash = "sha256-seYQEHjmKzdAcZ9uBNv7qDnpdQLHq/nHzND3Y3k+O9E=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    protobuf
    cmake
  ];

  buildInputs = [
    rdkafka
  ];

  postPatch = ''
    substituteInPlace chirpstack/src/api/mod.rs \
      --replace-fail "../ui/build" "${ui}"
  '';

  # Skip database dependend tests
  checkFlags = [
    "--skip adr::default::test::test_handle"
    "--skip adr::lora_lr_fhss::test::test_handle"
    "--skip adr::lr_fhss::test::test_handle"
    "--skip api::application::test::test_application"
    "--skip api::application::test::test_aws_sns_integration"
    "--skip api::application::test::test_azure_service_bus_integration"
    "--skip api::application::test::test_gcp_pub_sub_integration"
    "--skip api::application::test::test_http_integration"
    "--skip api::application::test::test_ifttt_integration"
    "--skip api::application::test::test_influx_db_integration"
    "--skip api::application::test::test_lora_cloud_integration"
    "--skip api::application::test::test_my_devices_integration"
    "--skip api::application::test::test_pilot_things_integration"
    "--skip api::application::test::test_things_board_integration"
    "--skip api::auth::validator::test::application"
    "--skip api::auth::validator::test::device"
    "--skip api::auth::validator::test::device_profile"
    "--skip api::auth::validator::test::device_profile_test"
    "--skip api::auth::validator::test::device_queue"
    "--skip api::auth::validator::test::gateway"
    "--skip api::auth::validator::test::multicast_group"
    "--skip api::auth::validator::test::tenant_user"
    "--skip api::auth::validator::test::validate_active_user"
    "--skip api::auth::validator::test::validate_active_user_or_key"
    "--skip api::auth::validator::test::validate_is_admin"
    "--skip api::auth::validator::test::validate_tenant"
    "--skip api::backend::test::test_async_response"
    "--skip api::device::test::test_device"
    "--skip api::device_profile::test::test_device_profile"
    "--skip api::device_profile_template::test::test_device_profile_template"
    "--skip api::gateway::test::test_gateway"
    "--skip api::gateway::test::test_gateway_duty_cycle_stats"
    "--skip api::gateway::test::test_gateway_stats"
    "--skip api::multicast::test::test_multicast_group"
    "--skip api::relay::test::test_relay"
    "--skip api::tenant::test::test_tenant"
    "--skip api::user::test::test_user"
    "--skip downlink::data::test::test_configure_fwd_limit_req"
    "--skip downlink::data::test::test_get_next_device_queue_item"
    "--skip downlink::data::test::test_request_ctrl_uplink_list"
    "--skip downlink::data::test::test_update_end_device_conf"
    "--skip downlink::data::test::test_update_filter_list"
    "--skip downlink::data::test::test_update_relay_conf"
    "--skip downlink::data::test::test_update_uplink_list"
    "--skip downlink::helpers::tests::test_select_downlink_gateway"
    "--skip integration::redis::test::test_redis"
    "--skip maccommand::ctrl_uplink_list::test::test_response"
    "--skip maccommand::dev_status::test::test_handle"
    "--skip maccommand::device_mode_ind::test::test_handle"
    "--skip maccommand::notify_new_end_device::test::test_handle"
    "--skip storage::api_key::test::api_key"
    "--skip storage::application::test::test_application"
    "--skip storage::device::test::test_device"
    "--skip storage::device::test::test_device_session"
    "--skip storage::device::test::test_get_with_class_b_c_queue_items"
    "--skip storage::device_gateway::test::test_rx_info"
    "--skip storage::device_keys::test::test_device_keys"
    "--skip storage::device_profile::test::test_device_profile"
    "--skip storage::device_profile_template::test::test_device_profile_test"
    "--skip storage::device_queue::test::test_flush_queue"
    "--skip storage::device_queue::test::test_get_max_f_cnt_down"
    "--skip storage::device_queue::test::test_queue_item"
    "--skip storage::downlink_frame::test::test_downlink_frame"
    "--skip storage::gateway::test::test_gateway"
    "--skip storage::gateway::test::test_relay_gateway"
    "--skip storage::mac_command::test::test_mac_command"
    "--skip storage::metrics::test::test_absolute"
    "--skip storage::metrics::test::test_counter"
    "--skip storage::metrics::test::test_day"
    "--skip storage::metrics::test::test_day_dst_transition"
    "--skip storage::metrics::test::test_gauge"
    "--skip storage::metrics::test::test_hour"
    "--skip storage::metrics::test::test_minute"
    "--skip storage::metrics::test::test_month"
    "--skip storage::multicast::test::test_device"
    "--skip storage::multicast::test::test_gateway"
    "--skip storage::multicast::test::test_get_schedulable_queue_items"
    "--skip storage::multicast::test::test_multicast_group"
    "--skip storage::multicast::test::test_queue"
    "--skip storage::relay::test::test_relay"
    "--skip storage::search::test::test_global_search"
    "--skip storage::tenant::test::test_tenant"
    "--skip storage::tenant::test::test_tenant_user"
    "--skip storage::user::test::test_user"
    "--skip stream::api_request::tests::test_log_request"
    "--skip test::class_a_pr_test::test_fns_uplink"
    "--skip test::class_a_pr_test::test_sns_dev_not_found"
    "--skip test::class_a_pr_test::test_sns_roaming_not_allowed"
    "--skip test::class_a_pr_test::test_sns_uplink"
    "--skip test::class_a_test::test_gateway_filtering"
    "--skip test::class_a_test::test_lorawan_10_adr"
    "--skip test::class_a_test::test_lorawan_10_device_disabled"
    "--skip test::class_a_test::test_lorawan_10_device_queue"
    "--skip test::class_a_test::test_lorawan_10_device_status_request"
    "--skip test::class_a_test::test_lorawan_10_end_to_end_enc"
    "--skip test::class_a_test::test_lorawan_10_errors"
    "--skip test::class_a_test::test_lorawan_10_mac_commands"
    "--skip test::class_a_test::test_lorawan_10_rx_delay"
    "--skip test::class_a_test::test_lorawan_10_skip_f_cnt"
    "--skip test::class_a_test::test_lorawan_10_uplink"
    "--skip test::class_a_test::test_lorawan_11_device_queue"
    "--skip test::class_a_test::test_lorawan_11_errors"
    "--skip test::class_a_test::test_lorawan_11_mac_commands"
    "--skip test::class_a_test::test_lorawan_11_receive_window_selection"
    "--skip test::class_a_test::test_lorawan_11_uplink"
    "--skip test::class_a_test::test_region_config_id_filtering"
    "--skip test::class_b_test::test_downlink_scheduler"
    "--skip test::class_b_test::test_uplink"
    "--skip test::class_c_test::test_downlink_scheduler"
    "--skip test::multicast_test::test_multicast"
    "--skip test::otaa_js_test::test_js"
    "--skip test::otaa_pr_test::test_fns"
    "--skip test::otaa_pr_test::test_sns"
    "--skip test::otaa_pr_test::test_sns_roaming_not_allowed"
    "--skip test::otaa_test::test_gateway_filtering"
    "--skip test::otaa_test::test_lorawan_10"
    "--skip test::otaa_test::test_lorawan_11"
    "--skip test::relay_class_a_test::test_lorawan_10"
    "--skip test::relay_otaa_test::test_lorawan_10"
    "--skip test::test_integration"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit (nixosTests) chirpstack;
    };
  };

  meta = with lib; {
    description = "LoRaWAN Network Server";
    homepage = "https://www.chirpstack.io";
    license = licenses.mit;
    maintainers = with maintainers; [ stv0g ];
    platforms = platforms.linux;
    mainProgram = "chirpstack";
  };
}
