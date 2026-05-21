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
  version = "0-unstable-2026-05-15";

  src = fetchFromGitHub {
    owner = "42Paris";
    repo = "minilibx-linux";
    rev = "b8de9b411818f2e56dd2f4f23c5aa9bffc18a612";
    hash = "sha256-LTZeVxa4NdGOai/GIrhPbWwXO7Vj7ct/gexeC81IvDw=";
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
