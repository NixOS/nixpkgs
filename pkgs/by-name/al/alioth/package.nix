{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "alioth";
<<<<<<< HEAD
  version = "0.10.0";
=======
  version = "0.9.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "google";
    repo = "alioth";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-lR3TrGCjOp+NprAXUttLWSEi2LDGCOpW9Bg5TH7reys=";
=======
    hash = "sha256-6+Co+Du08Hr2U8vifsD5kYfgSERVkFZ2BpqE1wXEDkM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  # Checks use `debug_assert_eq!`
  checkType = "debug";

<<<<<<< HEAD
  cargoHash = "sha256-lZam3/GuKIoGdWFhOc8E54yHVr0ah39HGiMVmNwCDlI=";

  separateDebugInfo = true;

  meta = {
    homepage = "https://github.com/google/alioth";
    description = "Experimental Type-2 Hypervisor in Rust implemented from scratch";
    license = lib.licenses.asl20;
    mainProgram = "alioth";
    maintainers = with lib.maintainers; [ astro ];
=======
  cargoHash = "sha256-W01mqG0QlKDP/b4NbVm/ohySF3v5j38BLZEuMwkFffs=";

  separateDebugInfo = true;

  meta = with lib; {
    homepage = "https://github.com/google/alioth";
    description = "Experimental Type-2 Hypervisor in Rust implemented from scratch";
    license = licenses.asl20;
    mainProgram = "alioth";
    maintainers = with maintainers; [ astro ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
