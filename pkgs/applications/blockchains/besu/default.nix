{ lib, stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname = "besu";
  version = "23.10.3";

  src = fetchurl {
    url = "https://hyperledger.jfrog.io/artifactory/${pname}-binaries/${pname}/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-c8g0zzLHu+JV19jMfKXR6w34QwuRFJNcjc86Z1sqy8I=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r bin $out/
    mkdir -p $out/lib
    cp -r lib $out/
    wrapProgram $out/bin/${pname} --set JAVA_HOME "${jre}"
  '';

  meta = with lib; {
    description = "An enterprise-grade Java-based, Apache 2.0 licensed Ethereum client";
    homepage = "https://www.hyperledger.org/projects/besu";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    platforms = platforms.all;
    maintainers = with maintainers; [ mmahut ];
  };
}
