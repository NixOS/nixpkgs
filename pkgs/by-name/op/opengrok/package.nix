{
  lib,
  stdenv,
  fetchurl,
  jre,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "opengrok";
  version = "1.14.12";

  # binary distribution
  src = fetchurl {
    url = "https://github.com/oracle/opengrok/releases/download/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-D67KpbmuqInnfymNc9QvreTVjZmzNuxoswD/ZxTlHx8=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -a * $out/
    makeWrapper ${jre}/bin/java $out/bin/opengrok \
      --add-flags "-jar $out/lib/opengrok.jar"

    runHook postInstall
  '';

  meta = {
    description = "Source code search and cross reference engine";
    mainProgram = "opengrok";
    homepage = "https://opengrok.github.io/OpenGrok/";
    changelog = "https://github.com/oracle/opengrok/releases/tag/${version}";
    license = lib.licenses.cddl;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
