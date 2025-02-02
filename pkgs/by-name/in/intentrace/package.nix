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

  cargoHash = "sha256-LkLSPFCfQxBb5DJZ67I7xPxzIYqTzKccyLW0S65/MLU=";

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
