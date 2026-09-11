{
  rustPlatform,
  fetchFromGitHub,
  lib,
  nixosTests,
  cacert,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rust-federation-tester";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "MTRNord";
    repo = "rust-federation-tester";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KHRG+5AeK7h7k7LoTtcIjGmPYlVcV2ZwpJN8iDsBfHg=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  cargoHash = "sha256-nTcE8eqQO0CFdeH0jjT6m1fd4qhG7e/CDpdZHkBq9f8=";
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
