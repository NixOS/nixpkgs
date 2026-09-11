{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  freetype,
  libpng,
  libjpeg,
  libGL,
  libGLU,
  freeglut,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fsnav";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "jtsiomb";
    repo = "fsnav";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Bt1QRqtJkVFR1uMzmB3OUyqyzUyJdQyQdbMOfMyWJOc=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    freetype
    libpng
    libjpeg
  ]
  ++ (lib.optionals stdenv.hostPlatform.isLinux [
    libGL
    libGLU
    freeglut
  ]);

  makeFlags = [
    "PREFIX=$(out)"
    "CC=${stdenv.cc.targetPrefix}cc"
    "CXX=${stdenv.cc.targetPrefix}c++"
  ];

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/fsnav
  '';

  meta = {
    description = "3D filesystem navigator inspired by SGI FSN";
    homepage = "https://github.com/jtsiomb/fsnav";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ aaravrav ];
    mainProgram = "fsnav";
    platforms = with lib.platforms; linux ++ darwin;
    broken = !stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  };
})
