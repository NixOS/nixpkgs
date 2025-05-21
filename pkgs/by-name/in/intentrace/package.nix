{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

let
  version = "0.9.8";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "intentrace";

  src = fetchFromGitHub {
    owner = "sectordistrict";
    repo = "intentrace";
    tag = "v${version}";
    hash = "sha256-5QARHw9Z4+wYrxaAuSt9WjGR6qvSWAFIMdNOzE6FqfU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-m4kLpJeqAvDI8/1gjqRVkbOvyfcLfwi0y2iavvm25jw=";

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
