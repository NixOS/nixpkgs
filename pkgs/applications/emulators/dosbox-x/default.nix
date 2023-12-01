{ lib
, stdenv
, fetchFromGitHub
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
