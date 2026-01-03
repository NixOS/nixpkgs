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
  version = "0.67";

  src = fetchFromGitHub {
    owner = "al13n321";
    repo = "nnd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qiWzTZlv01IjNUwjzcNRfQrmVyUMTsKtfhXuZydg/Pc=";
  };

  cargoHash = "sha256-cx4V/DNafoqjfbtPl43Y09eF4fJ89x/ldx6qe70Qn/g=";

  meta = {
    description = "Debugger for Linux";
    homepage = "https://github.com/al13n321/nnd/tree/main";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ sinjin2300 ];
    mainProgram = "nnd";
  };
})
