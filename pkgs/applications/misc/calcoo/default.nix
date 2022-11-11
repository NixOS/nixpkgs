{ lib
, stdenv
, fetchzip
, ant
, jdk
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "calcoo";
  version = "2.1.0";

  src = fetchzip {
    url = "mirror://sourceforge/project/calcoo/calcoo/${version}/${pname}-${version}.zip";
    hash = "sha256-Bdavj7RaI5CkWiOJY+TPRIRfNelfW5qdl/74J1KZPI0=";
  };

  patches = [
    # Sets javac encoding option on build.xml
    ./0001-javac-encoding.diff
  ];

  nativeBuildInputs = [
    ant
    jdk
    makeWrapper
  ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    ant

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname}
    mv dist/lib/calcoo.jar $out/share/${pname}

    makeWrapper ${jdk}/bin/java $out/bin/calcoo \
    --add-flags "-jar $out/share/${pname}/calcoo.jar"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://calcoo.sourceforge.net/";
    description = "RPN and algebraic scientific calculator";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    inherit (jdk.meta) platforms;
  };
}
