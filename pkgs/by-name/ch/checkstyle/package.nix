{
  lib,
  stdenvNoCC,
  fetchurl,
  makeBinaryWrapper,
  jre,
}:

stdenvNoCC.mkDerivation rec {
  version = "11.0.1";
  pname = "checkstyle";

  src = fetchurl {
    url = "https://github.com/checkstyle/checkstyle/releases/download/checkstyle-${version}/checkstyle-${version}-all.jar";
    sha256 = "sha256-e8ByK4En2zMguzvBFQR4RE9n9gA1ZIMdpLz7wJGXMpo=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];
  buildInputs = [ jre ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -D $src $out/checkstyle/checkstyle-all.jar
    makeWrapper ${jre}/bin/java $out/bin/checkstyle \
      --add-flags "-jar $out/checkstyle/checkstyle-all.jar"
    runHook postInstall
  '';

  meta = {
    description = "Checks Java source against a coding standard";
    mainProgram = "checkstyle";
    longDescription = ''
      checkstyle is a development tool to help programmers write Java code that
      adheres to a coding standard. By default it supports the Sun Code
      Conventions, but is highly configurable.
    '';
    homepage = "https://checkstyle.org/";
    changelog = "https://checkstyle.org/releasenotes.html#Release_${version}";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ pSub ];
    platforms = jre.meta.platforms;
  };
}
