{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "24.6.4";
  sha256 = "0pic9jncnal93g4kd8c02yl00jm0s11rax3bzz37l0iljjppxr6c";
  vendorHash = "sha256-oNEXVyNvdDsEws+8WklYxpxeTOykLEvmvyY8FAIB6HU=";
}
