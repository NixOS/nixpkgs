{
  lib,
  stdenv,
  fetchurl,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "airsonic";
  version = "10.6.2";

  src = fetchurl {
    url = "https://github.com/airsonic/airsonic/releases/download/v${finalAttrs.version}/airsonic.war";
    hash = "sha256-lLF9anhZqcAp3LzcZy9NSb1gW/Rr33SsUeoNWT22eGA=";
  };

  buildCommand = ''
    mkdir -p "$out/webapps"
    cp "$src" "$out/webapps/airsonic.war"
  '';

  stdenv = {
    tests = {
      airsonic-starts = nixosTests.airsonic;
    };
  };

  meta = {
    description = "Personal media streamer";
    homepage = "https://airsonic.github.io";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ disassembler ];
  };
})
