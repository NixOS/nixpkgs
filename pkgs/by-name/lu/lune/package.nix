{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cmake,
}:
rustPlatform.buildRustPackage rec {
  pname = "lune";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "filiptibell";
    repo = "lune";
    tag = "v${version}";
    hash = "sha256-pWOGaVugfnwaA4alFP85ha+/iaN8x6KOVnx38vfFk78=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-cq7Sgq9f2XpVTgEOMfR/G7sTqcWLwuJBgG9U+h4IMWQ=";

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  checkFlags = [
    # require internet access
    "--skip=tests::net_request_codes"
    "--skip=tests::net_request_compression"
    "--skip=tests::net_request_https"
    "--skip=tests::net_request_methods"
    "--skip=tests::net_request_query"
    "--skip=tests::net_request_redirect"
    "--skip=tests::net_socket_basic"
    "--skip=tests::net_socket_wss"
    "--skip=tests::net_socket_wss_rw"
    "--skip=tests::net_tcp_basic"
    "--skip=tests::net_tcp_info"
    "--skip=tests::net_tcp_tls"
    "--skip=tests::roblox_instance_custom_async"

    # uses root as the CWD
    "--skip=tests::process_exec_cwd"
  ];

  meta = with lib; {
    description = "Standalone Luau script runtime";
    mainProgram = "lune";
    homepage = "https://github.com/lune-org/lune";
    changelog = "https://github.com/lune-org/lune/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ lammermann ];
  };
}
