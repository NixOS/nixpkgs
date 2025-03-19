{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

let
  version = "0.6.2";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "intentrace";

  src = fetchFromGitHub {
    owner = "sectordistrict";
    repo = "intentrace";
    tag = "v${version}";
    hash = "sha256-hmQLedKyrk07RPloe39HKtZPJJjDUqLb/D4dvJfuWrM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-XSo9XqO3DiW3PXUW8RxTWqIxN1jx8WJKw16soP7kM1s=";

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
