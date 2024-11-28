{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

let
  version = "0.2.6";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "intentrace";

  src = fetchFromGitHub {
    owner = "sectordistrict";
    repo = "intentrace";
    rev = "refs/tags/v${version}";
    hash = "sha256-e47hauVg5Ncp0C5y6RkfKfxMHbBvpKrVoUq3aJxTf2E=";
  };

  cargoHash = "sha256-MAbOEJdMkt6efTGdmimMpYAx39JnQlnOlbIHIGICgp8=";

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
