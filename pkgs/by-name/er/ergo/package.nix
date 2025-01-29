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
  version = "5.0.24";

  src = fetchurl {
    url = "https://github.com/ergoplatform/ergo/releases/download/v${version}/ergo-${version}.jar";
    sha256 = "sha256-+dpSgqJGHUNzIBQBbfbeclB5t+NyaluGRTCZ4OESZu8=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    makeWrapper ${jre}/bin/java $out/bin/ergo --add-flags "-jar $src"
  '';

  passthru.tests = { inherit (nixosTests) ergo; };

  meta = with lib; {
    description = "Open protocol that implements modern scientific ideas in the blockchain area";
    homepage = "https://ergoplatform.org/en/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.cc0;
    platforms = platforms.all;
    maintainers = with maintainers; [ mmahut ];
    mainProgram = "ergo";
  };
}
