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
<<<<<<< HEAD
  version = "0.66";
=======
  version = "0.59";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "al13n321";
    repo = "nnd";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-92M5HSkXxlup+4vuQlf2AYIhYfIpRc5yGFgRcpLnHQY=";
  };

  cargoHash = "sha256-lS/nfRuf5u6+0ZBbuBfeQNU6G4jDWj02OBie7LxpYsc=";
=======
    hash = "sha256-TQEE4opjaNCCIVW1kyEhaRA85mFLxUL+eUdSNXcQ36g=";
  };

  cargoHash = "sha256-z+pW6urmgpPhgD0/0BSQ6Lnw6p1jyYNWuo/JUE5EpqU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Debugger for Linux";
    homepage = "https://github.com/al13n321/nnd/tree/main";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ sinjin2300 ];
    mainProgram = "nnd";
  };
})
