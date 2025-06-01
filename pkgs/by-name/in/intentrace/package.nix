{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

let
  version = "0.10.3";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "intentrace";

  src = fetchFromGitHub {
    owner = "sectordistrict";
    repo = "intentrace";
    tag = "v${version}";
    hash = "sha256-mCMARX6y9thgYJpDRFnWGZJupdk+EhVaBGbwABYYjNA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-BZ+P6UT9bBuAX9zyZCA+fI2pUtV8b98oPcQDwJV5HC8=";

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
