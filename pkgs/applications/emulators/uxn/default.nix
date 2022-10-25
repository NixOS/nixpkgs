{ lib
, stdenv
, fetchFromSourcehut
, SDL2
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uxn";
  version = "unstable-2022-10-22";

  src = fetchFromSourcehut {
    owner = "~rabbits";
    repo = "uxn";
    rev = "1b2049e238df96f32335edf1c6db35bd09f8b42d";
    hash = "sha256-lwms+qUelfpTC+i2m5b3dW7ww9298YMPFdPVsFrwcDQ=";
  };

  postPatch = ''
    sed -e 's|-L/usr/local/lib ||' build.sh
  '';

  buildInputs = [
    SDL2
  ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    pushd .
    CC="${stdenv.cc.targetPrefix}cc" ./build.sh
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -d $out/bin/ $out/share/uxn/

    cp bin/uxn{asm,cli,emu} $out/bin/
    cp -r projects $out/share/uxn/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://wiki.xxiivv.com/site/uxn.html";
    description = "An assembler and emulator for the Uxn stack machine";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; unix;
    broken = stdenv.isDarwin;
  };
})
