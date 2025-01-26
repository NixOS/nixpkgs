{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
  gcc,
  valgrind,
}:
# gcc and valgrind are not strict dependencies, they could be made
# optional. They are here because plm can only help you learn C if you
# have them installed.
stdenv.mkDerivation rec {
  pname = "plm";
  version = "2.9.3";

  src = fetchurl {
    url = "https://github.com/BuggleInc/PLM/releases/download/v${version}/plm-${version}.jar";
    sha256 = "0i9ghx9pm3kpn9x9n1hl10zdr36v5mv3drx8lvhsqwhlsvz42p5i";
    name = "${pname}-${version}.jar";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    jre
    gcc
    valgrind
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$prefix/bin"

    makeWrapper ${jre}/bin/java $out/bin/plm \
      --add-flags "-jar $src" \
      --prefix PATH : "$PATH"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Free cross-platform programming exerciser";
    mainProgram = "plm";
    homepage = "https://people.irisa.fr/Martin.Quinson/Teaching/PLM/";
    license = licenses.gpl3;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
