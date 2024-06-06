{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
}:
rustPlatform.buildRustPackage {
  pname = "piped-proxy";
  version = "0-unstable-2024-06-03";

  src = fetchFromGitHub {
    owner = "TeamPiped";
    repo = "piped-proxy";
    rev = "d1d1c0f0f21f18a01e7345d939c543bb8ffec0ce";
    hash = "sha256-PJYUzSV0Pkvpvs8rAL28ysFkSUAlWf1Uig7aHx1Ma6o=";
  };

  cargoHash = "sha256-ET4rIXV30IKrkvivqwMAQWiwia9t4gghqJERHcFVfLk=";

  passthru.tests = {
    piped = nixosTests.piped;
  };

  meta = {
    description = "A proxy for Piped written in Rust";
    homepage = "https://github.com/TeamPiped/piped-proxy";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [defelo];
  };
}
