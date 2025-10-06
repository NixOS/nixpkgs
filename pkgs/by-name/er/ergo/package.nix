{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "ergo";
  version = "6.0.1";

  src = fetchurl {
    url = "https://github.com/ergoplatform/ergo/releases/download/v${version}/ergo-${version}.jar";
    sha256 = "sha256-ByvHXgXFdoHbc+lWEK82I/I50Q1aoe3SSI2JeaTjEC4=";
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
}
