{
  lib,
  stdenv,
  fetchFromGitHub,
  raylib,
}:

stdenv.mkDerivation {
  pname = "raylib-games";
  version = "2022-10-24";

  src = fetchFromGitHub {
    owner = "raysan5";
    repo = "raylib-games";
    rev = "e00d77cf96ba63472e8316ae95a23c624045dcbe";
    hash = "sha256-N9ip8yFUqXmNMKcvQuOyxDI4yF/w1YaoIh0prvS4Xr4=";
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

  meta = with lib; {
    description = "Collection of games made with raylib";
    homepage = "https://www.raylib.com/games.html";
    license = licenses.zlib;
    inherit (raylib.meta) platforms;
  };
}
