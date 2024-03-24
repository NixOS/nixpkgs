{ hostPlatform, callPackage }: {
  brave = if hostPlatform.isAarch64
    then callPackage ./generic.nix { } rec {
      pname = "brave";
      version = "1.64.109";
      url = "https://github.com/brave/brave-browser/releases/download/v${version}/brave-browser_${version}_arm64.deb";
      hash = "sha256-5/tFuPuvk5fr7/ZKhFLLlikh8GnZaSHF9l0XU+0x2DA=";
      platform = "aarch64-linux";
    } else if hostPlatform.isx86_64 then callPackage /generic.nix { } rec {
      pname = "brave";
      version = "1.64.109";
      url = "https://github.com/brave/brave-browser/releases/download/v${version}/brave-browser_${version}_amd64.deb";
      hash = "sha256-36igba0U3p8i7t91RxeG6PqlKYyHDDlj295ICcYmCNc=";
      platform = "x86_64-linux";
    } else throw "Unsupported platform.";
}
