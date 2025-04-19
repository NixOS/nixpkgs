{
  stdenv,
  lib,
  makeWrapper,
  jre,
  gradle,
}:

stdenv.mkDerivation rec {
  name = "crossfire-gridarta";
  version = "2025-03";

  src = builtins.fetchGit {
    url = "https://git.code.sf.net/p/gridarta/gridarta";
    rev = "e4aad7e53c596e87b91f850aac8fea8dfa17ff71";
    submodules = true;
    shallow = true;
  };

  nativeBuildInputs = [ jre gradle makeWrapper ];

  patches = [ ./gridarta-gradle8.patch ];

  buildPhase = ''
    gradle :src:crossfire:createEditorJar
  '';

  installPhase = ''
    mkdir -pv $out/share/java $out/bin
    cp src/crossfire/build/libs/CrossfireEditor.jar $out/share/java/

    makeWrapper ${jre}/bin/java $out/bin/crossfire-gridarta \
      --add-flags "-jar $out/share/java/CrossfireEditor.jar" \
      --set _JAVA_OPTIONS '-Dawt.useSystemAAFontSettings=on' \
      --set _JAVA_AWT_WM_NONREPARENTING 1
  '';

  meta = with lib; {
    description = "Map and archetype editor for the Crossfire free MMORPG";
    homepage = "http://crossfire.real-time.com/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
