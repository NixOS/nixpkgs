{
  stdenv,
  lib,
  makeWrapper,
  gradle,
  jre,
  ffmpeg
}:

stdenv.mkDerivation rec {
  name = "crossfire-jxclient";
  version = "2025-01";

  src = builtins.fetchGit {
    url = "https://git.code.sf.net/p/crossfire/jxclient";
    ref = "master";
    rev = "01471f0fdf7a5fd8b4ea6d5b49bde7edead5c505";
    submodules = true;
    shallow = true;
  };

  nativeBuildInputs = [ jre gradle makeWrapper ffmpeg ];

  buildPhase = ''
    gradle :createJar
  '';

  installPhase = ''
    mkdir -pv $out/share/java $out/bin
    cp jxclient.jar $out/share/java/jxclient.jar

    makeWrapper ${jre}/bin/java $out/bin/crossfire-jxclient \
      --add-flags "-jar $out/share/java/jxclient.jar" \
      --set _JAVA_OPTIONS '-Dawt.useSystemAAFontSettings=on' \
      --set _JAVA_AWT_WM_NONREPARENTING 1
  '';

  meta = with lib; {
    description = "Java-based fullscreen client for the Crossfire free MMORPG";
    homepage = "http://crossfire.real-time.com/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
