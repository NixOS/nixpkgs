{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  autoreconfHook,
  ffmpeg,
  fluidsynth,
  freetype,
  glib,
  libicns,
  libpcap,
  libpng,
  libslirp,
  libxkbfile,
  libXrandr,
  makeWrapper,
  ncurses,
  pkg-config,
  python3,
  SDL2,
  SDL2_net,
  testers,
  yad,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dosbox-x";
  version = "2025.05.03";

  src = fetchFromGitHub {
    owner = "joncampbell123";
    repo = "dosbox-x";
    rev = "dosbox-x-v${finalAttrs.version}";
    hash = "sha256-VYJn1ddDkSHpWVsE7NunwRvuAVRqbvCNw/TzkWe8TLQ=";
  };

  # sips is unavailable in sandbox, replacing with imagemagick breaks build due to wrong Foundation propagation(?) so don't generate resolution variants
  # iconutil is unavailable, replace with png2icns from libicns
  # Patch bad hardcoded compiler
  # Don't mess with codesign, doesn't seem to work?
  postPatch = ''
    substituteInPlace Makefile.am \
      --replace-fail 'sips' '## sips' \
      --replace-fail 'iconutil -c icns -o contrib/macos/dosbox.icns src/dosbox.iconset' 'png2icns contrib/macos/dosbox.icns contrib/macos/dosbox-x.png' \
      --replace-fail 'g++' "$CXX" \
      --replace-fail 'codesign' '## codesign'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    patchShebangs appbundledeps.py
  '';

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libicns
    python3
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libxkbfile
    libXrandr
  ];

  # Tests for SDL_net.h for modem & IPX support, not automatically picked up due to being in SDL2 subdirectory
  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev SDL2_net}/include/SDL2";

  configureFlags = [ "--enable-sdl2" ];

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ]; # https://github.com/joncampbell123/dosbox-x/issues/4436

  # Build optional App Bundle target, which needs at least one arch-suffixed binary
  postBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    cp src/dosbox-x src/dosbox-x-$(uname -m)
    make dosbox-x.app
  '';

  postInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      wrapProgram $out/bin/dosbox-x \
        --prefix PATH : ${lib.makeBinPath [ yad ]}
    ''
    # Install App Bundle, wrap regular binary into bundle's binary to get the icon working
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir $out/Applications
      mv dosbox-x.app $out/Applications/
      mv $out/bin/dosbox-x $out/Applications/dosbox-x.app/Contents/MacOS/dosbox-x
      makeWrapper $out/Applications/dosbox-x.app/Contents/MacOS/dosbox-x $out/bin/dosbox-x
    '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    # Version output on stderr, program returns status code 1
    command = "${lib.getExe finalAttrs.finalPackage} -version 2>&1 || true";
  };

  meta = {
    homepage = "https://dosbox-x.com";
    description = "Cross-platform DOS emulator based on the DOSBox project";
    longDescription = ''
      DOSBox-X is an expanded fork of DOSBox with specific focus on running
      Windows 3.x/9x/Me, PC-98 and 3D support via 3dfx.

      The full expanded feature list is available here:
      https://dosbox-x.com/wiki/DOSBox%E2%80%90X%E2%80%99s-Feature-Highlights
    '';
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      hughobrien
      OPNA2608
    ];
    platforms = lib.platforms.unix;
    mainProgram = "dosbox-x";
  };
})
