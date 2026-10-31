{
  lib,
  stdenv,
  fetchFromGitHub,
  raylib,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "raylib-games";
  version = "0-unstable-2026-08-13";

  src = fetchFromGitHub {
    owner = "raysan5";
    repo = "raylib-games";
    rev = "318688c759eaf391b36b9f893355c038fcf56419";
    hash = "sha256-KVxpYNdFMOxzDQ4PHC4uBYVl+ng1WF5mEYBxeK4Mv5k=";
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Collection of games made with raylib";
    homepage = "https://www.raylib.com/games.html";
    license = lib.licenses.zlib;
    inherit (raylib.meta)
      platforms
      maintainers
      teams
      ;
  };
}
