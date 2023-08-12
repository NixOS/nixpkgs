{ lib
, stdenv
, fetchFromSourcehut
, SDL2
, unstableGitUpdater
}:

stdenv.mkDerivation {
  pname = "uxn";
  version = "unstable-2023-08-10";

  src = fetchFromSourcehut {
    owner = "~rabbits";
    repo = "uxn";
    rev = "a394dcb999525ac56ea37d0563d35849964b6d6a";
    hash = "sha256-3Q8460pkoATKCEqfa+OfpQ4Lp18Ro5i84s88pkz+uzU=";
  };

  buildInputs = [
    SDL2
  ];

  postPatch = ''
     sed -i -e 's|UXNEMU_LDFLAGS="$(brew.*$|UXNEMU_LDFLAGS="$(sdl2-config --cflags --libs)"|' build.sh
  '';

  buildPhase = ''
    runHook preBuild

    ./build.sh --no-run

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -d $out/bin/ $out/share/uxn/

    cp bin/uxnasm bin/uxncli bin/uxnemu $out/bin/
    cp -r projects $out/share/uxn/

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://wiki.xxiivv.com/site/uxn.html";
    description = "An assembler and emulator for the Uxn stack machine";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ AndersonTorres kototama ];
    inherit (SDL2.meta) platforms;
  };
}
