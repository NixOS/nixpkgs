{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dumbpipe";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "dumbpipe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8iubiYZTOCGD7BjqMDnOi3Or1b7cYffL2HBEikUCXF8=";
  };

  cargoHash = "sha256-nc/xGi+9kX9OAGLs2uTHMp8Z9+6DLKTvVki2RgNAUV0=";

  __darwinAllowLocalNetworking = true;

  # On Darwin, dumbpipe invokes CoreFoundation APIs that read ICU data from the
  # system. Ensure these paths are accessible in the sandbox to avoid segfaults
  # during checkPhase.
  sandboxProfile = ''
    (allow file-read* (subpath "/usr/share/icu"))
  '';

  checkFlags = [
    # These tests require network access
    "--skip=connect_listen_ctrlc_connect"
    "--skip=connect_listen_ctrlc_listen"
    "--skip=connect_tcp_happy"
    "--skip=unix_socket_tests::unix_socket_roundtrip"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Connect A to B - Send Data";
    homepage = "https://www.dumbpipe.dev/";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ cameronfyfe ];
    mainProgram = "dumbpipe";
  };
})
