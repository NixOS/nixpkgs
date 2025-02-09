{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

let
  version = "0.4.2";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "intentrace";

  src = fetchFromGitHub {
    owner = "sectordistrict";
    repo = "intentrace";
    tag = "v${version}";
    hash = "sha256-ZcGZK4GX78ls3nHb7SBKszmZXMAbCxS4osW3MLqgnHQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Z3T4mupwUqOSP+iAmy7Ps1EZlyV9cDvnfXBZwH1NFaA=";

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
