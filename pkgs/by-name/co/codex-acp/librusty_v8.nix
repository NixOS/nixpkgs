# auto-generated file -- DO NOT EDIT!
{
  lib,
  stdenv,
  fetchurl,
}:

fetchurl {
  name = "librusty_v8-147.4.0";
  url = "https://github.com/denoland/rusty_v8/releases/download/v147.4.0/librusty_v8_release_${stdenv.hostPlatform.rust.rustcTarget}.a.gz";
  hash =
    {
      x86_64-linux = "sha256-Cd3vbFEZKv/wVBExoO+cAPgxhdI5HaqxgDgqOr82rJU=";
      aarch64-linux = "sha256-lMPw/eAFFAT8obaR8opJbXjbgw58+0maBEyxpeOllFU=";
      x86_64-darwin = "sha256-+ppR8dMhVTSZL0PPar+DlKZ0K+E5N7WfdXXfBTYel+Y=";
      aarch64-darwin = "sha256-fnR0DD7woOj8DiaKJYYSPpg0D+lDVmjNwSiPrvtzYq4=";
    }
    .${stdenv.hostPlatform.system}
    or (throw "librusty_v8 147.4.0 is not available for ${stdenv.hostPlatform.system}");
  meta = {
    version = "147.4.0";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
