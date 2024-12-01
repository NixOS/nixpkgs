{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "discrete-scroll";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "emreyolcu";
    repo = "discrete-scroll";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FYYtJUl1tvMu9yMK5VpHmMeM6otDIpoOvSGTjYNPBr0=";
  };

  buildPhase = ''
    runHook preBuild
    $CC -O3 -framework ApplicationServices DiscreteScroll/main.c
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 a.out $out/bin/discretescroll
    runHook postInstall
  '';

  meta = {
    description = "Fix for OS X's scroll wheel problem";
    homepage = "https://github.com/emreyolcu/discrete-scroll";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bb2020 ];
    platforms = lib.platforms.darwin;
  };
})
