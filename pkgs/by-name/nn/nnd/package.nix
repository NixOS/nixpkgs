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
  version = "0.68";

  src = fetchFromGitHub {
    owner = "al13n321";
    repo = "nnd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-77WKsk/kKWJjSwikXtLDWY0pRf1pC6YkY9c9xDtheUI=";
  };

  cargoHash = "sha256-I9TcZQqKjR4awufmT8fM883YDeyNZUozHaoZfEaE6+0=";

  meta = {
    description = "Debugger for Linux";
    homepage = "https://github.com/al13n321/nnd/tree/main";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ sinjin2300 ];
    mainProgram = "nnd";
  };
})
