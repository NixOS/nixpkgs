{ lib, stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname = "besu";
<<<<<<< HEAD
  version = "23.7.2";

  src = fetchurl {
    url = "https://hyperledger.jfrog.io/artifactory/${pname}-binaries/${pname}/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-90sywaNDy62QqIqlkna0xe7+pGQ+5UKrorv4mPha4kI=";
=======
  version = "23.1.2";

  src = fetchurl {
    url = "https://hyperledger.jfrog.io/artifactory/${pname}-binaries/${pname}/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-PTpwmjqrmToIAbQSpHGddOMZ+ULdwT+w8ws8SlTRJTg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
