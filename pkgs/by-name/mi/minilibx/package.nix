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
  version = "0-unstable-2021-10-30";

  src = fetchFromGitHub {
    owner = "42Paris";
    repo = "minilibx-linux";
    rev = "7dc53a411a7d4ae286c60c6229bd1e395b0efb82";
    hash = "sha256-aRYMpaPC7dC6EHmmXugvwcQnaizRCQZKFcQX0K2MLM4=";
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
