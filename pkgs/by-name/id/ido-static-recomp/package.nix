{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ido-static-recomp";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "decompals";
    repo = "ido-static-recomp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-35/ak74K1T6xSosRtgOZZdO7zZnWQAg7ZZMgyEqe4Gc=";
  };

  buildPhase = ''
    runHook preBuild

    make setup
    make VERSION=5.3 RELEASE=1
    make VERSION=7.1 RELEASE=1

    runHook postBuild
  '';

  enableParallelBuilding = true;

  installPhase = ''
    install -Dm755 -t $out/bin/5.3/ build/5.3/out/*
    install -Dm755 -t $out/bin/7.1/ build/7.1/out/*
  '';

  meta = {
    description = "Static Recompilation of IRIX Programs";
    homepage = "https://github.com/decompals/ido-static-recomp";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ qubitnano ];
    platforms = lib.platforms.all;
  };
})
