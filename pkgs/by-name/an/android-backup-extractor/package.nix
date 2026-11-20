{
  stdenv,
  lib,
  fetchurl,
  makeWrapper,
  jre,
}:

stdenv.mkDerivation {
  pname = "android-backup-extractor";
  version = "0-unstable-2025-10-27";

  src = fetchurl {
    url = "https://github.com/nelenkov/android-backup-extractor/releases/download/latest/abe-540a57d.jar";
    hash = "sha256-7RAJLOZJ8/TXN7boS0w1t4r/wHu/RwN3/N6HGmTMfhM=";
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

  meta = {
    description = "Utility to extract and repack Android backups created with adb backup";
    mainProgram = "abe";
    homepage = "https://github.com/nelenkov/android-backup-extractor";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
