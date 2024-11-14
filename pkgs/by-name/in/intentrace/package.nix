{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

let
  version = "0.4.1";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "intentrace";

  src = fetchFromGitHub {
    owner = "sectordistrict";
    repo = "intentrace";
    rev = "refs/tags/v${version}";
    hash = "sha256-9BlCDtWnBDJuo6ovDi347jAQSOG8LizJAyQ/xN+HJ0w=";
  };

  cargoHash = "sha256-eJlAQpkI+RgfpDJGP9evWH28nU891PF4jeRpf2Os4Ts=";

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
