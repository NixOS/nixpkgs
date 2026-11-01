{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  writeShellApplication,
  cmake,
  libcdio,
  libpng,
  libusb1,
  openssl,
  pkg-config,
  sdl3,
  sdl3-ttf,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "np2kai";
  version = "0.86rev22-unstable-2026-09-05";

  src = fetchFromGitHub {
    owner = "AZO234";
    repo = "NP2kai";
    rev = "5939e0c6d5985c4c08fc70f289a83290e5d3e6f7";
    hash = "sha256-b7l/0V9+Wb7ytVCq9oNESLqbZTKJGaICT8A4v/YMXEA=";
    fetchSubmodules = true;
  };

  # - Don't require Git
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'if(NOT git_result EQUAL 0)' 'if(FALSE)'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libcdio
    libpng
    libusb1
    openssl
    sdl3
    sdl3-ttf
    zlib
  ];

  cmakeFlags = [
    (lib.strings.cmakeBool "BUILD_SDL" true)
    (lib.strings.cmakeBool "BUILD_WX" false)
    (lib.strings.cmakeBool "BUILD_X" false)
    (lib.strings.cmakeBool "BUILD_HAXM" false)
    (lib.strings.cmakeBool "USE_HAXM" false)
    (lib.strings.cmakeFeature "USE_SDL" "3")
    # On this branch, BUILD_I286 builds the i286 targets instead of the IA-32 ones
    (lib.strings.cmakeBool "BUILD_I286" false)
  ];

  env = {
    NP2KAI_VERSION = finalAttrs.version;
    NP2KAI_HASH = builtins.substring 0 7 finalAttrs.src.rev;
    # GCC 14 incompatibility
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
  };

  passthru.updateScript = unstableGitUpdater {
    # 0.86 version prefix is implied, add it back for our versioning
    tagConverter = lib.getExe (writeShellApplication {
      name = "update-np2kai";
      text = ''
        sed -e 's/^rev\./0.86rev/g'
      '';
    });
  };

  meta = {
    description = "PC-9801 series emulator";
    homepage = "https://github.com/AZO234/NP2kai";
    # Information on the repo is untrustworthy.
    # This is a fork from the original np2, which lacked any licensing information for most of its code -> Unfree
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ iedame ];
    mainProgram = "sdlnp21kai";
    platforms = lib.platforms.x86;
  };
})
