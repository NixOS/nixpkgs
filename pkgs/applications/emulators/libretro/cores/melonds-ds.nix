{
  lib,
  cmake,
  fetchFromGitHub,
  mkLibretroCore,
  libGLU,
  libGL,
  git,
}:
let
  date = fetchFromGitHub {
    owner = "HowardHinnant";
    repo = "date";
    rev = "1ead6715dec030d340a316c927c877a3c4e5a00c";
    hash = "sha256-0dlwfPFUpIUp45KxfJIcD7J7ls6csPGx//qSt9Wp2CI=";
  };

  embed-binaries = fetchFromGitHub {
    owner = "andoalon";
    repo = "embed-binaries";
    rev = "078b62beba97e8192c99bfb16d5e17220cfc7598";
    hash = "sha256-EkK+ZCbrZ2Y9wJ864OIwRWDfHcmxzKMco0QAkLOQOwY=";
  };

  fmt = fetchFromGitHub {
    owner = "fmtlib";
    repo = "fmt";
    rev = "11.0.2";
    hash = "sha256-IKNt4xUoVi750zBti5iJJcCk3zivTt7nU12RIf8pM+0=";
  };
  
  glm = fetchFromGitHub {
    owner = "g-truc";
    repo = "glm";
    rev = "e7970a8b26732f1b0df9690f7180546f8c30e48e";
    hash = "sha256-VqNYg+rya0vUQ5dpvuz6hGAlVWiqArd/5yLxr9Vg8NA=";
  };
  
  libretro-common = fetchFromGitHub {
    owner = "JesseTG";
    repo = "libretro-common";
    rev = "8e2b884db16711a999a0e46a02a3dc0be294b048";
    hash = "sha256-NYxi1BADUgMAtLfmYcOIhTAnmJ/LYd0OyfPKx6lorw4=";
  };

  libslirp = fetchFromGitHub {
    owner = "JesseTG";
    repo = "libslirp-mirror";
    rev = "e61dbd459c8c06607b3a84694489427e8ec60f17";
    hash = "sha256-WQIJjnNJHF63gNfznnrGt4jAzrhHfslOATsjcbfbAg4=";
  };

  melonDS = fetchFromGitHub {
    owner = "JesseTG";
    repo = "melonDS";
    rev = "f6692dff8c0c53f77639a08e5e746a286312bb41";
    hash = "sha256-EeXYibPV9BPazC/i5UqXEd4BKlIZbNbPNgpsoo4ws7k=";
  };

  pntr = fetchFromGitHub {
    owner = "robloach";
    repo = "pntr";
    rev = "650237a524ea4fc953de7223a1587c83f2696794";
    hash = "sha256-qGWPlHkcW/wavxRN76SHiEKCl2b1VZR+O9YrZOFZL0I=";
  };

  span-lite = fetchFromGitHub {
    owner = "martinmoene";
    repo = "span-lite";
    rev = "00afc281a8c3c7657bb9c5b000d6e7082c1bbc7f";
    hash = "sha256-EBSN8Bh1ymFyWTUPQ6OS9c75B/mJysNS2VIqR0qG9zI=";
  };

  # # tracy is not built by default
  # tracy = fetchFromGitHub {
  #   owner = "wolfpld";
  #   repo = "tracy";
  #   rev = "v0.11.1";
  #   hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  # };

  yamc = fetchFromGitHub {
    owner = "yohhoy";
    repo = "yamc";
    rev = "4e015a7e8eb0d61c34e6928676c8c78881a72d73";
    hash = "sha256-J5wAqF5yQ5KYArJJyKzaqscWsXq+KAPKXybYfVgasXs=";
  };

  zlib = fetchFromGitHub {
    owner = "madler";
    repo = "zlib";
    rev = "v1.3.1";
    hash = "sha256-TkPLWSN5QcPlL9D0kc/yhH0/puE9bFND24aj5NVDKYs=";
  };
in
mkLibretroCore {
  core = "melonds-ds";
  version = "0-unstable-2026-03-03";
  
  src = fetchFromGitHub {
    owner = "JesseTG";
    repo = "melonds-ds";
    rev = "bac0256dc6a8736c5a228f57c562257e45fd49f3";
    hash = "sha256-EeXYibPV9BPazC/i5UqXEd4BKlIZbNbPNgpsoo4ws7k=";
  };

  extraBuildInputs = [
    libGLU
    libGL
  ];

  extraNativeBuildInputs = [
    cmake
    git
  ];

  cmakeFlags = [
    "-DFETCHCONTENT_SOURCE_DIR_DATE=${date}"
    "-DFETCHCONTENT_SOURCE_DIR_EMBED-BINARIES=${embed-binaries}"
    "-DFETCHCONTENT_SOURCE_DIR_FMT=${fmt}"
    "-DFETCHCONTENT_SOURCE_DIR_GLM=${glm}"
    "-DFETCHCONTENT_SOURCE_DIR_LIBRETRO-COMMON=${libretro-common}"
    "-DFETCHCONTENT_SOURCE_DIR_LIBSLIRP=${libslirp}"
    "-DFETCHCONTENT_SOURCE_DIR_MELONDS=${melonDS}"
    "-DFETCHCONTENT_SOURCE_DIR_PNTR=${pntr}"
    "-DFETCHCONTENT_SOURCE_DIR_SPAN-LITE=${span-lite}"
    # "-DFETCHCONTENT_SOURCE_DIR_TRACY=${tracy}" # not built by default
    "-DFETCHCONTENT_SOURCE_DIR_YAMC=${yamc}"
    "-DFETCHCONTENT_SOURCE_DIR_ZLIB=${zlib}"
  ];

  meta = {
    description = "Enhanced remake of the melonDS core for libretro";
    homepage = "https://github.com/JesseTG/melonds-ds";
    license = lib.licenses.gpl3Plus;
  };
}

