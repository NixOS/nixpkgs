{
  lib,
  stdenv,
  fetchFromGitHub,
  nasm,
  pkg-config,
  alsa-lib,
  curl,
  flac,
  fluidsynth,
  freetype,
  libjpeg,
  libmad,
  libmpeg2,
  libogg,
  libtheora,
  libvorbis,
  libGLU,
  libGL,
  libx11,
  SDL2,
  zlib,
  cctools,
  fetchpatch,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scummvm";
  version = "2026.3.0";

  src = fetchFromGitHub {
    owner = "scummvm";
    repo = "scummvm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wFEYg3hRVNVlxpw3xP8O8s4ILKy487k5hyWENaLiOlw=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    nasm
    pkg-config
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
      libGLU
      libGL
    ]
    ++ [
      curl
      freetype
      flac
      fluidsynth
      libjpeg
      libmad
      libmpeg2
      libogg
      libtheora
      libvorbis
      SDL2
      libx11
      zlib
    ];

  dontDisableStatic = true;

  enableParallelBuilding = true;

  configurePlatforms = [ "host" ];
  configureFlags = [
    "--enable-release"
  ];

  preConfigure = ''
    PATH="${lib.getDev SDL2}/bin:$PATH"
  '';

  # They use 'install -s', that calls the native strip instead of the cross
  postConfigure = ''
    sed -i "s/-c -s/-c -s --strip-program=''${STRIP@Q}/" ports.mk
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace config.mk \
      --replace-fail ${stdenv.hostPlatform.config}-ranlib ${cctools}/bin/ranlib
  '';

  patches = [
    # Nancy Drew build error. Remove after next release.
    (fetchpatch {
      url = "https://github.com/scummvm/scummvm/commit/e2ef63e84123c199ab55de445e406aa626147e10.patch";
      hash = "sha256-sdabI0W6Apav/pgGBxY+usHUakxECZtYu2tdyi8gojk=";
    })
  ];

  env.NIX_CFLAGS_COMPILE = toString [ "-fpermissive" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Program to run certain classic graphical point-and-click adventure games (such as Monkey Island)";
    longDescription = ''
      ScummVM is a program which allows you to run a variety of classic
      graphical point-and-click adventure games and role-playing games,
      provided you already have their data files. It reimplements the original
      engines (SCUMM, SCI, AGS, and many more) so those games can be played
      on systems and hardware they were never designed for.
    '';
    homepage = "https://www.scummvm.org/";
    changelog = "https://github.com/scummvm/scummvm/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ peterhoeg ];
    mainProgram = "scummvm";
    platforms = lib.platforms.unix;
  };
})
