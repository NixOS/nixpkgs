{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "aardvark-dns";
<<<<<<< HEAD
  version = "1.17.0";
=======
  version = "1.16.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "containers";
    repo = "aardvark-dns";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-NJ1ViJpN6fBO9U1RkCkqyr6JXiHa5zX1BQAGGqKWVYY=";
  };

  cargoHash = "sha256-rQQ+Y7uWsjGSp6CeIs794/mGPceJ31OTxAmRonP1WL0=";
=======
    hash = "sha256-mC+PP5sXt2O0CgxxyzS2WjtQe0RjuKNCamrjRY7qBP8=";
  };

  cargoHash = "sha256-e/VxQgpTOS4snM78BewvloWap9cU+Vzlahlr00BWmVY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  passthru.tests = { inherit (nixosTests) podman; };

  meta = {
    changelog = "https://github.com/containers/aardvark-dns/releases/tag/${src.rev}";
    description = "Authoritative dns server for A/AAAA container records";
    homepage = "https://github.com/containers/aardvark-dns";
    license = lib.licenses.asl20;
    teams = with lib.teams; [ podman ];
    platforms = lib.platforms.linux;
    mainProgram = "aardvark-dns";
  };
}
