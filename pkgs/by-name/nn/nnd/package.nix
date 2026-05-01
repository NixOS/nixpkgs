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
  version = "0.59";

  src = fetchFromGitHub {
    owner = "al13n321";
    repo = "nnd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TQEE4opjaNCCIVW1kyEhaRA85mFLxUL+eUdSNXcQ36g=";
  };

  cargoHash = "sha256-z+pW6urmgpPhgD0/0BSQ6Lnw6p1jyYNWuo/JUE5EpqU=";

  meta = {
    description = "Debugger for Linux";
    homepage = "https://github.com/al13n321/nnd/tree/main";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ sinjin2300 ];
    mainProgram = "nnd";
  };
})
