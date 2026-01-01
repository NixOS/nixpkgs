{
  lib,
  fetchFromGitHub,
  rustPlatform,
<<<<<<< HEAD
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dumbpipe";
  version = "0.33.0";
=======
}:

rustPlatform.buildRustPackage rec {
  pname = "dumbpipe";
  version = "0.27.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "dumbpipe";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
    hash = "sha256-8iubiYZTOCGD7BjqMDnOi3Or1b7cYffL2HBEikUCXF8=";
  };

  cargoHash = "sha256-nc/xGi+9kX9OAGLs2uTHMp8Z9+6DLKTvVki2RgNAUV0=";
=======
    rev = "v${version}";
    hash = "sha256-IF9KL5Rf7PsM8T/ZdFfycFRDUGmpAqdWyCPFaCGN/ko=";
  };

  cargoHash = "sha256-qrFARMY5kjxirCJvCW5O1QPU+yaAh16AvULGqbKUY+w=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  __darwinAllowLocalNetworking = true;

  # On Darwin, dumbpipe invokes CoreFoundation APIs that read ICU data from the
  # system. Ensure these paths are accessible in the sandbox to avoid segfaults
  # during checkPhase.
  sandboxProfile = ''
    (allow file-read* (subpath "/usr/share/icu"))
  '';

<<<<<<< HEAD
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
=======
  meta = with lib; {
    description = "Connect A to B - Send Data";
    homepage = "https://www.dumbpipe.dev/";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ cameronfyfe ];
    mainProgram = "dumbpipe";
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
