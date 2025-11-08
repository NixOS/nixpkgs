{
  stdenv,
  lib,
  fetchgit,
  makeWrapper,
  jre,
  gradle,
}:

stdenv.mkDerivation {
  name = "crossfire-gridarta";
  version = "2025-04";

  src = fetchgit {
    url = "https://git.code.sf.net/p/gridarta/gridarta";
    rev = "9ff39a63071fc76141117eac97a27c07d312cfb5";
    hash = "sha256-UotvRJey0SXhKjyKo0L7MiDtqvsBOUcT0315fkAKwb0=";
  };

  nativeBuildInputs = [
    jre
    gradle
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild
    gradle :src:crossfire:createEditorJar
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -pv $out/share/java $out/bin
    cp src/crossfire/build/libs/CrossfireEditor.jar $out/share/java/

    makeWrapper ${jre}/bin/java $out/bin/crossfire-gridarta \
      --add-flags "-jar $out/share/java/CrossfireEditor.jar" \
      --prefix _JAVA_OPTIONS " " "-Dawt.useSystemAAFontSettings=gasp" \
      --set _JAVA_AWT_WM_NONREPARENTING 1

    runHook postInstall
  '';

  meta = with lib; {
    description = "Map and archetype editor for the Crossfire free MMORPG";
    homepage = "http://crossfire.real-time.com/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
