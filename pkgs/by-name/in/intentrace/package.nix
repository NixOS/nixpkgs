{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

let
  version = "0.9.5";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "intentrace";

  src = fetchFromGitHub {
    owner = "sectordistrict";
    repo = "intentrace";
    tag = "v${version}";
    hash = "sha256-9frNVC9jSWYiElTP6z+xoU5GW9QKxfxvt2v5jkhyH9I=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-SinuOXJ9Z+HQMTAKm+pUzx6jrLMypoK3f2DLmRaI70E=";

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
