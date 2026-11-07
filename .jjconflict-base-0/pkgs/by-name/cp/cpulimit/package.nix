{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cpulimit";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "opsengine";
    repo = "cpulimit";
    rev = "v${finalAttrs.version}";
    sha256 = "1dz045yhcsw1rdamzpz4bk8mw888in7fyqk1q1b3m1yk4pd1ahkh";
  };

  env.NIX_CFLAGS_COMPILE = "-std=gnu17";

  patches = [
    ./remove-sys-sysctl.h.patch
    ./get-missing-basename.patch
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp src/cpulimit $out/bin
  '';

  meta = {
    homepage = "https://github.com/opsengine/cpulimit";
    description = "CPU usage limiter";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
    mainProgram = "cpulimit";
    maintainers = [ lib.maintainers.jsoo1 ];
  };
})
