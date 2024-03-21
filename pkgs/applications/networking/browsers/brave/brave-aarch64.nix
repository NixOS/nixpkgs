{ callPackage }:
callPackage ./generic.nix { } rec {
  pname = "brave";
  version = "1.64.109";
  url = "https://github.com/brave/brave-browser/releases/download/v${version}/brave-browser_${version}_arm64.deb";
  hash = "sha256-5/tFuPuvk5fr7/ZKhFLLlikh8GnZaSHF9l0XU+0x2DA=";
}
