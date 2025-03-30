{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

let
  version = "0.7.4";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "intentrace";

  src = fetchFromGitHub {
    owner = "sectordistrict";
    repo = "intentrace";
    tag = "v${version}";
    hash = "sha256-QmHGi8gSXccakvbFNMCCo/5m9BTgXqlLhh4DZxs30iw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-mvchd2LA2PUPDFQ3e0dmpMITmRL+wCxp8kLDo9fG/js=";

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
