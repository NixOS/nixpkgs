{
  stdenv,
  lib,
  fetchurl,
  makeWrapper,
  jre,
}:

stdenv.mkDerivation {
  pname = "android-backup-extractor";
  version = "0-unstable-2025-01-15";

  src = fetchurl {
    url = "https://github.com/nelenkov/android-backup-extractor/releases/download/latest/abe-62310d4.jar";
    hash = "sha256-KY85I8OJCH7z6U6y9UbelFb3rvBVCid+AjJcucNGLdA=";
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
