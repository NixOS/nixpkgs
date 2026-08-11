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
  version = "0-unstable-2026-06-20";

  src = fetchFromGitHub {
    owner = "42Paris";
    repo = "minilibx-linux";
    rev = "f07d00f07c5c652223f505b526f84dab73cf2598";
    hash = "sha256-DPQ+hc4yJ7nh9UTJg+ustE+Gp+YM05RzsqiKdWQevkQ=";
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
