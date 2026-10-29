{
  lib,
  fetchFromGitHub,
  glm,
  libslirp,
  fmt_11,
  span-lite,
  howard-hinnant-date,
  libGL,
  libGLU,
  cmake,
  mkLibretroCore,
}:
let
  # https://github.com/JesseTG/melonds-ds/blob/33c48260402865ef77667487528efd5ca7ce1233/cmake/FetchDependencies.cmake#L44
  melonDS-src = fetchFromGitHub {
    owner = "JesseTG";
    repo = "melonDS";
    rev = "f6692dff8c0c53f77639a08e5e746a286312bb41";
    hash = "sha256-+bMqpjspQzyRci3u0PEpR9oX3S9LBqP223y6VfI2j14=";
  };
  libretro-common-src = fetchFromGitHub {
    owner = "JesseTG";
    repo = "libretro-common";
    rev = "8e2b884db16711a999a0e46a02a3dc0be294b048";
    hash = "sha256-NYxi1BADUgMAtLfmYcOIhTAnmJ/LYd0OyfPKx6lorw4=";
  };
  embed-binaries-src = fetchFromGitHub {
    owner = "andoalon";
    repo = "embed-binaries";
    rev = "21f28cabbba02cd657578c70b7aedd0f141467ff";
    hash = "sha256-iW3DBGdp/ykE3EoGcuirq5V5lKV0vemzIjDFrINzQPM=";
  };
  pntr-src = fetchFromGitHub {
    owner = "robloach";
    repo = "pntr";
    rev = "650237a524ea4fc953de7223a1587c83f2696794";
    hash = "sha256-qGWPlHkcW/wavxRN76SHiEKCl2b1VZR+O9YrZOFZL0I=";
  };
  yamc-src = fetchFromGitHub {
    owner = "yohhoy";
    repo = "yamc";
    rev = "4e015a7e8eb0d61c34e6928676c8c78881a72d73";
    hash = "sha256-J5wAqF5yQ5KYArJJyKzaqscWsXq+KAPKXybYfVgasXs=";
  };
  # using nixpkgs zlib gives a linking error
  zlib-src = fetchFromGitHub {
    owner = "madler";
    repo = "zlib";
    rev = "570720b0c24f9686c33f35a1b3165c1f568b96be";
    hash = "sha256-5g/Jo8M/jvkgV0NofSAV4JdwJSk5Lyv9iGRb2Kz/CC0=";
  };
in
mkLibretroCore rec {
  core = "melondsds";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "JesseTG";
    repo = "melonds-ds";
    rev = "33c48260402865ef77667487528efd5ca7ce1233";
    hash = "sha256-n5MZ6BWUWRi+jz34EbL+SeSkjFZeqQNXE3hS6JzS424=";
  };

  patches = [ ./patches/melondsds-noslirpcopy.patch ];
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "find_package(Git REQUIRED)" ""

    substituteInPlace src/libretro/CMakeLists.txt \
      --replace-fail "include(embed-binaries)" "include(${embed-binaries-src}/cmake/embed-binaries.cmake)"

    substituteInPlace cmake/FetchDependencies.cmake \
      --replace-fail "set_target_properties(example" "set_target_properties(zlib_example" \
      --replace-fail "set_target_properties(zlib_example64 minigzip64" "set_target_properties(zlib_example64"
  '';

  makefile = "";
  extraBuildInputs = [
    libGL
    libGLU
  ];
  extraNativeBuildInputs = [ cmake ];
  cmakeFlags = [
    (lib.cmakeBool "ENABLE_LTO_RELEASE" false) # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=121831
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5") # required by yamc

    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_MELONDS" "${melonDS-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_LIBRETRO-COMMON" "${libretro-common-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_EMBED-BINARIES" "${embed-binaries-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_GLM" "${glm.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_ZLIB" "${zlib-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_LIBSLIRP" "${libslirp.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_PNTR" "${pntr-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_FMT" "${fmt_11.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_YAMC" "${yamc-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_SPAN-LITE" "${span-lite.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_DATE" "${howard-hinnant-date.src}")
  ];

  postBuild = "cd src/libretro";

  meta = {
    description = "A remake of the libretro MelonDS core";
    homepage = "https://github.com/JesseTG/melonds-ds";
    changelog = "https://github.com/JesseTG/melonds-ds/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
  };
}
