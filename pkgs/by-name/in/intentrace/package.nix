{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

let
  version = "0.2.4";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "intentrace";

  src = fetchFromGitHub {
    owner = "sectordistrict";
    repo = "intentrace";
    rev = "refs/tags/v${version}";
    hash = "sha256-Bsis8tL2xahJT/qAFVbbd/CZ7n8KJYLPTIl1a1WHR4c=";
  };

  cargoHash = "sha256-pyGcQy7p0+Vqv3Khy1hLgahcOpqnbKKmRLZcKwkvVWw=";

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
