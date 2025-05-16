{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

let
  version = "0.9.7";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "intentrace";

  src = fetchFromGitHub {
    owner = "sectordistrict";
    repo = "intentrace";
    tag = "v${version}";
    hash = "sha256-24w5EQ3LQ7OxuVaqoLlUrYi2TmSLAfWGLNrkPcxMQMM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-pLGWXwpgTh/7SaDhs63jr+5Fpsiep1tfl9VlCEBrK1s=";

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
