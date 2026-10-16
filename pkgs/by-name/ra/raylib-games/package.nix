{
  lib,
  stdenv,
  fetchFromGitHub,
  raylib,
}:

stdenv.mkDerivation {
  pname = "raylib-games";
  version = "2026-05-07";

  src = fetchFromGitHub {
    owner = "raysan5";
    repo = "raylib-games";
    rev = "2175f1fe857aa91a749b66482359545f28cc596f";
    hash = "sha256-gmCbBcS5tlq6jySvDPUqZz4ONyDkSeUdgAd20c5sUls=";
  };

  buildInputs = [ raylib ];

  configurePhase = ''
    runHook preConfigure
    for d in *; do
      if [ -d $d/src/resources ]; then
        for f in $d/src/*.c $d/src/*.h; do
          sed "s|\"resources/|\"$out/resources/$d/|g" -i $f
        done
      fi
    done
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    for d in *; do
      if [ -f $d/src/Makefile ]; then
        make -C $d/src
      fi
    done
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/resources
    find . -type f -executable -exec cp {} $out/bin \;
    for d in *; do
      if [ -d "$d/src/resources" ]; then
        cp -ar "$d/src/resources" "$out/resources/$d"
      fi
    done
    runHook postInstall
  '';

  meta = {
    description = "Collection of games made with raylib";
    homepage = "https://www.raylib.com/games.html";
    license = lib.licenses.zlib;
    inherit (raylib.meta) platforms;
    hasNoMaintainersButDependents = true;
  };
}
