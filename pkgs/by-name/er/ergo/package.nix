{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ergo";
  version = "6.0.7";

  src = fetchurl {
    url = "https://github.com/ergoplatform/ergo/releases/download/v${finalAttrs.version}/ergo-${finalAttrs.version}.jar";
    sha256 = "sha256-hhb0BRM1zzt+4/MJmCG3snsZE7zYu1lX7X/ELd4m6fo=";
    meta.identifiers.purlParts = {
      type = "github";
      spec = "ergoplatform/ergo@${finalAttrs.version}";
    };
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    makeWrapper ${jre}/bin/java $out/bin/ergo --add-flags "-jar $src"
  '';

  passthru.tests = { inherit (nixosTests) ergo; };

  meta = {
    description = "Open protocol that implements modern scientific ideas in the blockchain area";
    homepage = "https://ergoplatform.org/en/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.cc0;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ mmahut ];
    mainProgram = "ergo";
  };
})
