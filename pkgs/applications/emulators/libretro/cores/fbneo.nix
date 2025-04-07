{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-04-05";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "c21c0a0393a1cc68db7250022d18039a30de51f4";
    hash = "sha256-AZyYUftVHlxR+QHCsIcNI2hTIEDYeInYPdmum++EtpU=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
