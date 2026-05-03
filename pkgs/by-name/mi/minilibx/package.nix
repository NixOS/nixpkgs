{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  libx11,
  libxext,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "minilibx";
  version = "0-unstable-2026-04-16";

  src = fetchFromGitHub {
    owner = "42Paris";
    repo = "minilibx-linux";
    rev = "a0ce07ba22460ee66e62b6c56d60b33946aeb13d";
    hash = "sha256-LyFCmuGXAAv7O9jrmfeIVeYoi7d1Mdw6e8u2Z0/yO4s=";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = [
    libx11
    libxext
  ];

  dontConfigure = true;

  makefile = "Makefile.mk";

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-std=gnu17";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{include,lib}
    cp mlx*.h $out/include
    cp libmlx*.a $out/lib
    installManPage man/man*/*

    runHook postInstall
  '';

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "Simple X-Window (X11R6) programming API in C";
    homepage = "https://github.com/42Paris/minilibx-linux";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.unix;
  };
}
