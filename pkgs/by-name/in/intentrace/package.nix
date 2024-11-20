{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

let
  version = "0.2.5";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "intentrace";

  src = fetchFromGitHub {
    owner = "sectordistrict";
    repo = "intentrace";
    rev = "refs/tags/v${version}";
    hash = "sha256-3Pbx/ZA9DYwNzsszSzodJub+G8uKuYuNZhlTDsvL0t4=";
  };

  cargoHash = "sha256-RZMhmqETPdcG0ofLPQdynaOFQuIx3H8j0mKR+SbOQ6s=";

  meta = {
    description = "Prettified Linux syscall tracing tool (like strace)";
    homepage = "https://github.com/sectordistrict/intentrace";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "intentrace";
    maintainers = with lib.maintainers; [
      cloudripper
      jk
    ];
  };
}
