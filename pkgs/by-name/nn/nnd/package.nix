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
  version = "0.73";

  src = fetchFromGitHub {
    owner = "al13n321";
    repo = "nnd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2I4Ph5xCf6XN335+LPWo+yN2VWAOVBoMmzx3OrhynJA=";
  };

  cargoHash = "sha256-w66JNHz6TJO1Fem4JrqlnBXX4yJC70I/OLjvICVdhMQ=";

  meta = {
    description = "Debugger for Linux";
    homepage = "https://github.com/al13n321/nnd/tree/main";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ sinjin2300 ];
    mainProgram = "nnd";
  };
})
