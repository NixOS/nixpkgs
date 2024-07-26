{ stdenv
, lib
, fetchFromGitHub
, enable16Bit ? true
, enable32Bit ? true

, enableSDL ? true
, withSDLVersion ? "2"
, SDL
, SDL_ttf
, SDL_mixer
, SDL2
, SDL2_ttf
, SDL2_mixer

, enableX11 ? stdenv.hostPlatform.isLinux
, automake
, autoconf
, autoconf-archive
, libtool
, pkg-config
, unzip
, gtk2
, libusb1
, libXxf86vm
, nasm
, libICE
, libSM

  # HAXM build succeeds but the binary segfaults, seemingly due to the missing HAXM kernel module
  # Enable once there is a HAXM kernel module option in NixOS? Or somehow bind it to the system kernel having HAXM?
  # Or leave it disabled by default?
  # https://github.com/intel/haxm/blob/master/docs/manual-linux.md
, enableHAXM ? false
}:

assert lib.assertMsg (enable16Bit || enable32Bit)
  "Must enable 16-Bit and/or 32-Bit system variant.";
assert lib.assertMsg (enableSDL || enableX11)
  "Must enable SDL and/or X11 graphics interfaces.";
assert lib.assertOneOf "withSDLVersion" withSDLVersion [ "1" "2" ];
assert enableHAXM -> (lib.assertMsg enableX11
  "Must enable X11 graphics interface for HAXM build.");
let
  inherit (lib) optional optionals optionalString;
  inherit (lib.strings) concatStringsSep concatMapStringsSep;
  isSDL2 = (withSDLVersion == "2");
  sdlInfix = optionalString isSDL2 "2";
  sdlDeps1 = [
    SDL
    SDL_ttf
    SDL_mixer
  ];
  sdlDeps2 = [
    SDL2
    SDL2_ttf
    SDL2_mixer
  ];
  sdlDepsBuildonly = if isSDL2 then sdlDeps1 else sdlDeps2;
  sdlDepsTarget = if isSDL2 then sdlDeps2 else sdlDeps1;
  sdlMakefileSuffix =
    if stdenv.hostPlatform.isWindows then "win"
    else if stdenv.hostPlatform.isDarwin then "mac"
    else "unix";
  sdlMakefiles = concatMapStringsSep " " (x: x + "." + sdlMakefileSuffix)
    (optionals enable16Bit [
      "Makefile"
    ] ++ optionals enable32Bit [
      "Makefile21"
    ]);
  sdlBuildFlags = concatStringsSep " "
    (optionals enableSDL [
      "SDL_VERSION=${withSDLVersion}"
    ]);
  sdlBins = concatStringsSep " "
    (optionals enable16Bit [
      "np2kai"
    ] ++ optionals enable32Bit [
      "np21kai"
    ]);
  x11ConfigureFlags = concatStringsSep " "
    ((
      if ((enableHAXM && (enable16Bit || enable32Bit)) || (enable16Bit && enable32Bit)) then [
        "--enable-build-all"
      ] else if enableHAXM then [
        "--enable-haxm"
      ] else if enable32Bit then [
        "--enable-ia32"
      ] else [ ]
    ) ++ optionals (!isSDL2) [
      "--enable-sdl"
      "--enable-sdlmixer"
      "--enable-sdlttf"

      "--enable-sdl2=no"
      "--enable-sdl2mixer=no"
      "--enable-sdl2ttf=no"
    ]);
  x11BuildFlags = concatStringsSep " " [
    "SDL2_CONFIG=sdl2-config"
    "SDL_CONFIG=sdl-config"
    "SDL_CFLAGS=\"$(sdl${sdlInfix}-config --cflags)\""
    "SDL_LIBS=\"$(sdl${sdlInfix}-config --libs) -lSDL${sdlInfix}_mixer -lSDL${sdlInfix}_ttf\""
  ];
  x11Bins = concatStringsSep " "
    (optionals enable16Bit [
      "xnp2kai"
    ] ++ optionals enable32Bit [
      "xnp21kai"
    ] ++ optionals enableHAXM [
      "xnp21kai_haxm"
    ]);
in
stdenv.mkDerivation rec {
  pname = "np2kai";
  version = "0.86rev22"; #update src.rev to commit rev accordingly

  src = fetchFromGitHub rec {
    owner = "AZO234";
    repo = "NP2kai";
    rev = "4a317747724669343e4c33ebdd34783fb7043221";
    sha256 = "0kxysxhx6jyk82mx30ni0ydzmwdcbnlxlnarrlq018rsnwb4md72";
  };

  configurePhase = ''
    export GIT_VERSION=${builtins.substring 0 7 src.rev}
    buildFlags="$buildFlags ''${enableParallelBuilding:+-j$NIX_BUILD_CORES}"
  '' + optionalString enableX11 ''
    cd x11
    substituteInPlace Makefile.am \
      --replace 'GIT_VERSION :=' 'GIT_VERSION ?='
    ./autogen.sh ${x11ConfigureFlags}
    ./configure ${x11ConfigureFlags}
    cd ..
  '';

  nativeBuildInputs = sdlDepsBuildonly
    ++ optionals enableX11 [
    automake
    autoconf
    autoconf-archive
    libtool
    pkg-config
    unzip
    nasm
  ];

  buildInputs = sdlDepsTarget
    ++ optionals enableX11 [
    gtk2
    libICE
    libSM
    libusb1
    libXxf86vm
  ];

  enableParallelBuilding = true;

  # TODO Remove when bumping past rev22
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-D_DARWIN_C_SOURCE";

  buildPhase = optionalString enableSDL ''
    cd sdl2
    for mkfile in ${sdlMakefiles}; do
      substituteInPlace $mkfile \
        --replace 'GIT_VERSION :=' 'GIT_VERSION ?='
      echo make -f $mkfile $buildFlags ${sdlBuildFlags} clean
      make -f $mkfile $buildFlags ${sdlBuildFlags} clean
      make -f $mkfile $buildFlags ${sdlBuildFlags}
    done
    cd ..
  '' + optionalString enableX11 ''
    cd x11
    make $buildFlags ${x11BuildFlags}
    cd ..
  '';

  installPhase = optionalString enableSDL ''
    cd sdl2
    for emu in ${sdlBins}; do
      install -D -m 755 $emu $out/bin/$emu
    done
    cd ..
  '' + optionalString enableX11 ''
    cd x11
    for emu in ${x11Bins}; do
      install -D -m 755 $emu $out/bin/$emu
    done
    cd ..
  '';

  meta = with lib; {
    description = "PC-9801 series emulator";
    homepage = "https://github.com/AZO234/NP2kai";
    license = licenses.mit;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.x86;
  };
}
