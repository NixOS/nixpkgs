{
  lib,
  fetchFromGitHub,
  pkgsCross,
}:
let
  inherit (pkgsCross.musl64) rustPlatform;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nnd";
  version = "0.72";

  src = fetchFromGitHub {
    owner = "al13n321";
    repo = "nnd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Uwe/GZ9fox9ovazYBZZjedzGEpm5cmWreBdgpBv61uY=";
  };

  cargoHash = "sha256-QPjvCIl3CNAq+rBV8mQWY+wCmRONs2VICTMBWdNZ8pQ=";

  meta = {
    description = "Debugger for Linux";
    homepage = "https://github.com/al13n321/nnd/tree/main";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ sinjin2300 ];
    mainProgram = "nnd";
  };
})
