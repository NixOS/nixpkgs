{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cmake,
}:
rustPlatform.buildRustPackage rec {
  pname = "lune";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "filiptibell";
    repo = "lune";
    tag = "v${version}";
    hash = "sha256-AbviyCy2nn6WHC575JKl/t3bM/4Myb+Wx5/buTvB4MY=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-QSQ+SsvLa7f9EVGi6i/SlpL8yWXVP47zkw4beDy5UIQ=";

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
