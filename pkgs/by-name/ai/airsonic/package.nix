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
    sha256 = "0q3qnqymj3gaa6n79pvbyidn1ga99lpngp5wvhlw1aarg1m7vccl";
  };

  buildCommand = ''
    mkdir -p "$out/webapps"
    cp "$src" "$out/webapps/airsonic.war"
  '';

  passthru.tests = {
    airsonic-starts = nixosTests.airsonic;
  };

  meta = {
    description = "Personal media streamer";
    homepage = "https://airsonic.github.io";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
  };
})
