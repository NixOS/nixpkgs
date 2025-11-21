{
  lib,
  stdenv,
  fetchFromGitHub,
  luabridge,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sjasmplus";
  version = "1.21.0";

  src = fetchFromGitHub {
    owner = "z00m128";
    repo = "sjasmplus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iPtH/Uviw9m3tcbG44aZO+I6vR95/waXUejpwPPCpqo=";
  };

  buildInputs = [ luabridge ];

  buildFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "CXX=${stdenv.cc.targetPrefix}c++"
  ];

  installPhase = ''
    runHook preInstall

    install -D --mode=0755 sjasmplus $out/bin/sjasmplus

    runHook postInstall
  '';

  meta = {
    homepage = "https://z00m128.github.io/sjasmplus/";
    description = "Z80 assembly language cross compiler based on the SjASM source code by Sjoerd Mastijn";
    mainProgram = "sjasmplus";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ electrified ];
  };
})
