{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "dumbpipe";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "dumbpipe";
    rev = "v${version}";
    hash = "sha256-nYM/QAG57491NqTAkqF1p3DeuVKDPvh6MUqYP/gAWyc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-lg/FmeCYL9WVvvEMnkQj1WaxFH+7rBBxgL9zfwSdaVE=";

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
