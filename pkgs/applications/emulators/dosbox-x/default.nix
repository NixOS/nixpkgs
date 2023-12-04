{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, alsa-lib
, AudioUnit
, autoreconfHook
, Carbon
, Cocoa
, ffmpeg
, fluidsynth
, freetype
, glib
, libpcap
, libpng
, libslirp
, libxkbfile
, libXrandr
, makeWrapper
, ncurses
, pkg-config
, SDL2
, SDL2_net
, testers
, yad
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dosbox-x";
  version = "2023.10.06";

  src = fetchFromGitHub {
    owner = "joncampbell123";
    repo = "dosbox-x";
    rev = "dosbox-x-v${finalAttrs.version}";
    hash = "sha256-YNYtYqcpTOx4xS/LXI53h3S+na8JVpn4w8Dhf4fWNBQ=";
  };

  patches = [
    # 2 patches which fix stack smashing when launching Windows 3.0
    # Remove when version > 2023.10.06
    (fetchpatch {
      name = "0001-dosbox-x-Attempt-to-fix-graphical-palette-issues-added-by-TTF-fix.patch";
      url = "https://github.com/joncampbell123/dosbox-x/commit/40bf135f70376b5c3944fe2e972bdb7143439bcc.patch";
      hash = "sha256-9whtqBkivYVYaPObyTODtwcfjaoK+rLqhCNZ7zVoiGI=";
    })
    (fetchpatch {
      name = "0002-dosbox-x-Fix-Sid-Meiers-Civ-crash.patch";
      url = "https://github.com/joncampbell123/dosbox-x/compare/cdcfb554999572e758b81edf85a007d398626b78..ac91760d9353c301e1da382f93e596238cf6d336.patch";
      hash = "sha256-G7HbUhYEi6JJklN1z3JiOTnWLuWb27bMDyB/iGwywuY=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    ffmpeg
    fluidsynth
    freetype
    glib
    libpcap
    libpng
    libslirp
    ncurses
    SDL2
    SDL2_net
    zlib
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libxkbfile
    libXrandr
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    AudioUnit
    Carbon
    Cocoa
  ];

  # Tests for SDL_net.h for modem & IPX support, not automatically picked up due to being in SDL2 subdirectory
  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev SDL2_net}/include/SDL2";

  configureFlags = [ "--enable-sdl2" ];

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ]; # https://github.com/joncampbell123/dosbox-x/issues/4436

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/dosbox-x \
      --prefix PATH : ${lib.makeBinPath [ yad ]}
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    # Version output on stderr, program returns status code 1
    command = "${lib.getExe finalAttrs.finalPackage} -version 2>&1 || true";
  };

  meta = {
    homepage = "https://dosbox-x.com";
    description = "A cross-platform DOS emulator based on the DOSBox project";
    longDescription = ''
      DOSBox-X is an expanded fork of DOSBox with specific focus on running
      Windows 3.x/9x/Me, PC-98 and 3D support via 3dfx.

      The full expanded feature list is available here:
      https://dosbox-x.com/wiki/DOSBox%E2%80%90X%E2%80%99s-Feature-Highlights
    '';
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ hughobrien OPNA2608 ];
    platforms = lib.platforms.unix;
    mainProgram = "dosbox-x";
  };
})
