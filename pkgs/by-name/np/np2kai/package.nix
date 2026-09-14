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
  libcdio,
  libusb1,
  libx11,
  openssl,
  pkg-config,
  SDL2,
  SDL2_ttf,

  enable16Bit ? true,
  enableX11 ? stdenv.hostPlatform.isLinux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "np2kai";
  version = "0.86rev22-unstable-2026-04-12";

  src = fetchFromGitHub {
    owner = "AZO234";
    repo = "NP2kai";
    rev = "5d47f3a04b0b8ea78f625eeec354ac132c80df06";
    hash = "sha256-R21FCSkL1BbwlZsxpQKSxdYqD3+72m1SX+rXOI4TYKU=";
  };

  patches = [
    ./1001-fixes.patch
  ];

  # - Don't require Git
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'if(NOT git_result EQUAL 0)' 'if(FALSE)'
  ''
  # Directory included is <SDL2_ttf>/include/SDL2
  + ''
    substituteInPlace {sdl,x}/fontmng.c \
      --replace-fail '<SDL2_ttf/SDL_ttf.h>' '<SDL_ttf.h>'
  ''
  # https://github.com/AZO234/NP2kai/issues/203
  # This really needs to be adjusted abit to really be POSIX-compliant & still Windows-compatible, but at least on Linux this should be fine...
  + ''
    substituteInPlace network/net.c \
      --replace-fail 'np2net_hThreadR = NULL' 'np2net_hThreadR = 0' \
      --replace-fail 'np2net_hThreadW = NULL' 'np2net_hThreadW = 0'
  ''
  # Stub out the IDE dialogue when the target doesn't support IDE
  # https://github.com/AZO234/NP2kai/issues/204
  + ''
    echo '#ifdef SUPPORT_IDEIO' > tmp
    cat x/gtk2/dialog_ide.c >> tmp
    echo '#endif' >> tmp
    mv tmp x/gtk2/dialog_ide.c
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals enableX11 [
    pkg-config
  ];

  buildInputs = [
    libcdio
    libusb1
    openssl
    SDL2
    SDL2_ttf
  ]
  ++ lib.optionals enableX11 [
    fontconfig
    freetype
    glib
    gtk2
    libx11
  ];

  cmakeFlags = [
    (lib.strings.cmakeBool "BUILD_SDL" true)
    (lib.strings.cmakeBool "BUILD_X" enableX11)
    (lib.strings.cmakeBool "BUILD_I286" enable16Bit)
    (lib.strings.cmakeBool "BUILD_HAXM" false)

    (lib.strings.cmakeFeature "USE_SDL" "2")
    (lib.strings.cmakeBool "USE_SDL_TTF" true)
    (lib.strings.cmakeBool "USE_X" enableX11)
    (lib.strings.cmakeBool "USE_HAXM" false)
  ];

  env = {
    NP2KAI_VERSION = finalAttrs.version;
    NP2KAI_HASH = builtins.substring 0 7 finalAttrs.src.rev;
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
    mainProgram = "${if enableX11 then "x" else "sdl"}np21kai_sdl2";
    platforms = lib.platforms.x86;
  };
})
