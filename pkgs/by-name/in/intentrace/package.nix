{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

let
  version = "0.10.4";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "intentrace";

  src = fetchFromGitHub {
    owner = "sectordistrict";
    repo = "intentrace";
    tag = "v${version}";
    hash = "sha256-zVRH6uLdBXI6VTu/R3pTNCjfx25089bYYTJZdvZIFck=";
  };

  cargoHash = "sha256-1n0fXOPVktqY/H/fPCgl0rA9xZM8QRXvZQgTadfwymo=";

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
