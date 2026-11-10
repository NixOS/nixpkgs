{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  rustPlatform,
  sqlite,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "essh";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "matthart1983";
    repo = "essh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-amv4//HWf928oKHiZEdhJo4EzeFDCDXSz2fy7PT0CIs=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-DWWzQ4T2FiOy8JzepAgsV0fr73RMSaNuoCDp55vaaJo=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ sqlite ];

  nativeCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "-V" ];

  checkFlags = [
    "--skip=mock_ssh_server_drives_real_connect_flow_end_to_end"
    "--skip=an_unroutable_address_fails_on_our_timeout_not_the_os"
    "--skip=an_unreachable_host_does_not_wedge_the_ui"
    "--skip=help_teaches_a_binding_that_works_everywhere"
    "--skip=it_starts_and_shows_the_launcher"
    "--skip=typing_in_the_launcher_filters_without_stalling"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=macos_command_set_produces_real_readings_on_this_host"
    "--skip=a_closed_port_is_named_as_refused_not_as_a_timeout"
  ];

  meta = {
    description = "SSH client to manage connections, keys and sessions";
    homepage = "https://github.com/matthart1983/essh";
    changelog = "https://github.com/matthart1983/essh/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "essh";
  };
})
