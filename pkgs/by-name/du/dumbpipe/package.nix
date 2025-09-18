{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "dumbpipe";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "dumbpipe";
    rev = "v${version}";
    hash = "sha256-IF9KL5Rf7PsM8T/ZdFfycFRDUGmpAqdWyCPFaCGN/ko=";
  };

  cargoHash = "sha256-qrFARMY5kjxirCJvCW5O1QPU+yaAh16AvULGqbKUY+w=";

  __darwinAllowLocalNetworking = true;

  # On Darwin, dumbpipe invokes CoreFoundation APIs that read ICU data from the
  # system. Ensure these paths are accessible in the sandbox to avoid segfaults
  # during checkPhase.
  sandboxProfile = ''
    (allow file-read* (subpath "/usr/share/icu"))
  '';

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
