{ stdenv
, lib
, fetchurl
, makeWrapper
, jre
}:

stdenv.mkDerivation rec {
  pname = "android-backup-extractor";
  version = "20210909062443-4c55371";

  src = fetchurl {
    url = "https://github.com/nelenkov/android-backup-extractor/releases/download/${version}/abe.jar";
    sha256 = "0ms241kb4h9y9apr637sb4kw5mml40c1ac0q4jcxhnwr3dr05w1q";
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ jre ];

  installPhase = ''
    runHook preInstall
    install -D $src $out/lib/android-backup-extractor/abe.jar
    makeWrapper ${jre}/bin/java $out/bin/abe --add-flags "-cp $out/lib/android-backup-extractor/abe.jar org.nick.abe.Main"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Utility to extract and repack Android backups created with adb backup";
    mainProgram = "abe";
    homepage = "https://github.com/nelenkov/android-backup-extractor";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = with maintainers; [ prusnak ];
  };
}
