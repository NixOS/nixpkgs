{ lib
, stdenv
, fetchFromSourcehut
, SDL2
}:

stdenv.mkDerivation rec {
  pname = "uxn";
  version = "0.pre+unstable=2021-08-30";

  src = fetchFromSourcehut {
    owner = "~rabbits";
    repo = pname;
    rev = "a2e40d9d10c11ef48f4f93d0dc86f5085b4263ce";
    hash = "sha256-/hxDYi814nQydm2iQk4NID4vpJ3BcBcM6NdL0iuZk5M=";
  };

  buildInputs = [
    SDL2
  ];

  dontConfigure = true;

  # It is easier to emulate build.sh script
  buildPhase = ''
    runHook preBuild

    cc -std=c89 -Wall -Wno-unknown-pragmas src/uxnasm.c -o uxnasm
    cc -std=c89 -Wall -Wno-unknown-pragmas src/uxn.c src/uxncli.c -o uxncli
    cc -std=c89 -Wall -Wno-unknown-pragmas src/uxn.c src/devices/ppu.c \
       src/devices/apu.c src/uxnemu.c $(sdl2-config --cflags --libs) -o uxnemu

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -d $out/bin/ $out/share/${pname}/

    cp uxnasm uxncli uxnemu $out/bin/
    cp -r projects $out/share/${pname}/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://wiki.xxiivv.com/site/uxn.html";
    description = "An assembler and emulator for the Uxn stack machine";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; unix;
  };
}
