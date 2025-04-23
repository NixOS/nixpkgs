{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

let
  version = "0.9.0";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "intentrace";

  src = fetchFromGitHub {
    owner = "sectordistrict";
    repo = "intentrace";
    tag = "v${version}";
    hash = "sha256-0TrM6Kb+5v7d98VJOsZXtsYZ4BGIbqXA3B6d4gqvl90=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-XHhu5B2GyZvKj9egbSOLJ7W/4BNdcGDYHYmb97Lhcpc=";

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
