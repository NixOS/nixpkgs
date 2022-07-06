{ lib, stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname = "besu";
  version = "22.4.3";

  src = fetchurl {
    url = "https://hyperledger.jfrog.io/artifactory/${pname}-binaries/${pname}/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-8mPoLI2+mqI6woY/gq6mKhG3HT3rmkFUMuD6YE/0p3w=";
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
    platforms = platforms.all;
    maintainers = with maintainers; [ mmahut ];
  };
}
