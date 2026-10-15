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
    hash = "sha256-cEIV2iXThzpWwGFi746NCCFe0Vzk319Vy4FrBn0h4Lc=";
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
