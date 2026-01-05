{
  lib,
  stdenv,
  fetchFromGitHub,
  nasm,
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
  libX11,
  SDL2,
  zlib,
  cctools,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scummvm";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "scummvm";
    repo = "scummvm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+MM47piuXuIBmAQd0g/cAg5t02qSQ0sw/DwFrMUSIAA=";
  };

  nativeBuildInputs = [ nasm ];

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
      libX11
      zlib
    ];

  dontDisableStatic = true;

  enableParallelBuilding = true;

  configurePlatforms = [ "host" ];
  configureFlags = [
    "--enable-release"
  ];

  # They use 'install -s', that calls the native strip instead of the cross
  postConfigure = ''
    sed -i "s/-c -s/-c -s --strip-program=''${STRIP@Q}/" ports.mk
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace config.mk \
      --replace-fail ${stdenv.hostPlatform.config}-ranlib ${cctools}/bin/ranlib
  '';

  NIX_CFLAGS_COMPILE = [ "-fpermissive" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Program to run certain classic graphical point-and-click adventure games (such as Monkey Island)";
    mainProgram = "scummvm";
    homepage = "https://www.scummvm.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.unix;
  };
})
