{
  rustPlatform,
  fetchFromGitHub,
  lib,
  nixosTests,
  cacert,
  fetchpatch,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rust-federation-tester";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "MTRNord";
    repo = "rust-federation-tester";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eohDvP+8mcEqYpHPe6NLVrGqONyyuTIP3Ytz3YZh6Gk=";
  };

  __structuredAttrs = true;

  cargoPatches = [
    # https://github.com/MTRNord/rust-federation-tester/pull/29 (use system CA store)
    (fetchpatch {
      url = "https://github.com/MTRNord/rust-federation-tester/commit/49936ed20a5fd59fa7620ad4c70f2154fd82a6db.patch";
      hash = "sha256-gSq2CR6l3ZQWAOVmftkkDk/B/VidkdQqFM2WGYPx2to=";
    })
    # https://github.com/MTRNord/rust-federation-tester/pull/28 (make listen addr configurable)
    (fetchpatch {
      url = "https://github.com/MTRNord/rust-federation-tester/commit/913c4ef4ee5b0af4dbedca53095ce7fdab36be3b.patch";
      hash = "sha256-mAzXuTAVLSspxMyOE7xzjtfpeI3UhYBFcUbU3ZAAs0s=";
    })
  ];

  cargoHash = "sha256-yZgid0bYmEOkK9cglswmdPGyUvDRTHY4b1/zdyeTiRM=";
  cargoTestFlags = finalAttrs.cargoBuildFlags;
  cargoBuildFlags = [
    "-p"
    "rust-federation-tester"
    "-p"
    "migration"
  ];

  nativeCheckInputs = [ cacert ];

  checkFlags = map (test: "--skip=${test}") [
    # Tests depending on network access
    "test_generate_json_report_ipv4_only_server"
    "test_generate_json_report_known_bad_servers"
    "test_generate_json_report_known_good_servers"
    "test_generate_json_report_valid_domain"
    "test_generate_json_report_with_port"
    "test_lookup_server_well_known_valid"
    "test_matrix_fed_srv_resolution_4msc4040"
    "test_matrix_srv_resolution_4s"
    "test_step2_explicit_port"
    "test_step3b_wellknown_explicit_port"
    "test_step3c_wellknown_matrix_fed_srv"
    "test_step3c_wellknown_matrix_srv"
    "test_step3d_wellknown_default_port"
    "test_step6_wellknown_fails_default_port"
    "test_generate_report"
    "test_concurrent_requests"
  ];

  passthru.tests = {
    inherit (nixosTests) matrix-synapse;
  };

  meta = {
    description = "Matrix-Federation-Tester in Rust";
    homepage = "https://connectivity-tester.mtrnord.blog/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ma27 ];
    platforms = lib.platforms.linux;
    mainProgram = "rust-federation-tester";
  };
})
