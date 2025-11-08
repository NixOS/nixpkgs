{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  writeShellApplication,
  cmake,
  fontconfig,
  freetype,
  glib,
  gtk2,
  libusb1,
  libX11,
  openssl,
  pkg-config,
  SDL2,
  SDL2_ttf,
  SDL2_mixer,

  enable16Bit ? true,
  enableX11 ? stdenv.hostPlatform.isLinux,
  # HAXM build succeeds but the binary segfaults, seemingly due to the missing HAXM kernel module
  # Enable once there is a HAXM kernel module option in NixOS? Or somehow bind it to the system kernel having HAXM?
  # Or leave it disabled by default?
  # https://github.com/intel/haxm/blob/master/docs/manual-linux.md
  enableHAXM ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "np2kai";
  version = "0.86rev22-unstable-2025-09-13";

  src = fetchFromGitHub {
    owner = "AZO234";
    repo = "NP2kai";
    rev = "02b08deb3833305251fb3ee6c5d59b0efb5b52ff";
    hash = "sha256-5aGlqYS05rUh+mD9TdCC9H+5JkOQCTn45UlEu7xcxLw=";
  };

  # Don't require Git
  # Use SDL2(_*) targets for correct includedirs
  # Add return type in ancient code
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'if(NOT git_result EQUAL 0)' 'if(FALSE)' \
      --replace-fail "\''${SDL2_DEFINE}" "" \
      --replace-fail "\''${SDL2_INCLUDE_DIR}" "" \
      --replace-fail "\''${SDL2_LIBRARY}" "SDL2::SDL2" \
      --replace-fail "\''${SDL2_MIXER_DEFINE}" "" \
      --replace-fail "\''${SDL2_MIXER_INCLUDE_DIR}" "" \
      --replace-fail "\''${SDL2_MIXER_LIBRARY}" "SDL2_mixer::SDL2_mixer" \
      --replace-fail "\''${SDL2_TTF_DEFINE}" "" \
      --replace-fail "\''${SDL2_TTF_INCLUDE_DIR}" "" \
      --replace-fail "\''${SDL2_TTF_LIBRARY}" "SDL2_ttf::SDL2_ttf" \

    substituteInPlace x/cmserial.c \
      --replace-fail 'convert_np2tocm(UINT port, UINT8* param, UINT32* speed) {' 'int convert_np2tocm(UINT port, UINT8* param, UINT32* speed) {'
    substituteInPlace x/gtk2/gtk_menu.c \
      --replace-fail 'xmenu_visible_item(MENU_HDL hdl, const char *name, BOOL onoff)' 'int xmenu_visible_item(MENU_HDL hdl, const char *name, BOOL onoff)'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals enableX11 [
    pkg-config
  ];

  buildInputs = [
    libusb1
    openssl
    SDL2
    SDL2_ttf
    SDL2_mixer
  ]
  ++ lib.optionals enableX11 [
    fontconfig
    freetype
    glib
    gtk2
    libX11
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SDL" true)
    (lib.cmakeBool "BUILD_X" enableX11)
    (lib.cmakeBool "BUILD_HAXM" enableHAXM)
    (lib.cmakeBool "BUILD_I286" enable16Bit)

    (lib.cmakeBool "USE_SDL" true)
    (lib.cmakeBool "USE_SDL2" true)
    (lib.cmakeBool "USE_SDL_MIXER" true)
    (lib.cmakeBool "USE_SDL_TTF" true)
    (lib.cmakeBool "USE_X" enableX11)
    (lib.cmakeBool "USE_HAXM" enableHAXM)
  ];

  enableParallelBuilding = true;

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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    mainProgram = "${if enableX11 then "x" else "sdl"}np21kai";
    platforms = lib.platforms.x86;
  };
})
